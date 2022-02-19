import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import protooClient from 'protoo-client';
import { v4 as uuidv4 } from 'uuid';
import axios from '@utils/axios';

import { modalService, lStorageService } from '@utils/service';

import { AdviseModal } from '@components/feedbacks/Modals';

const mediasoupClient = require('mediasoup-client');

/**
 * 실시간 방송을 시청 페이지 미디어 서버 제어 커스텀 훅
 *
 * @param {boolean} isLive 실시간 방송 유무
 * @param {Object} videoPlayerRef video dom ref
 * @param {String} roomId 실시간 방송 uuid
 * @returns {Object}
 * consumer: 미디어 서버에서 전달받은 미디어 정보 객체
 */

export default function useMediaSoupConsume(isLive, videoPlayerRef, roomId, id) {
  const userId = lStorageService.getItem('uuid');

  const [consumer, setConsumer] = useState(null);
  const [peer, setPeer] = useState(null);

  const navigate = useNavigate();

  const getRtpCapabilities = async peer => {
    const rptCapabilities = await peer.request('getRouterRtpCapabilities');
    return rptCapabilities;
  };

  const createConsumeDevice = async rptCapabilities => {
    const consumerDevice = new mediasoupClient.Device();

    await consumerDevice.load({
      routerRtpCapabilities: rptCapabilities,
    });

    return consumerDevice;
  };

  const createConsumeTransport = async (peer, consumeDevice) => {
    const recvTransportParams = await peer.request('createWebRtcTransport');
    const consumerTransport = consumeDevice.createRecvTransport(recvTransportParams);

    consumerTransport.on('connect', async ({ dtlsParameters }, callback, errback) => {
      try {
        await peer.request('connectConsume', {
          dtlsParameters,
        });
        callback();
      } catch (error) {
        errback(error);
      }
    });
    return consumerTransport;
  };

  const connectWithConsumeRouter = async (peer, consumerDevice, consumerTransport) => {
    const params = await peer.request('consume', {
      rtpCapabilities: consumerDevice.rtpCapabilities,
    });

    const consumer = await consumerTransport.consume({
      id: params.id,
      producerId: params.producerId,
      kind: params.kind,
      rtpParameters: params.rtpParameters,
    });

    const audioParams = await peer.request('audioConsume', {
      rtpCapabilities: consumerDevice.rtpCapabilities,
    });

    const audioConsumer = await consumerTransport.consume({
      id: audioParams.id,
      producerId: audioParams.producerId,
      kind: audioParams.kind,
      rtpParameters: audioParams.rtpParameters,
    });

    return { consumer, audioConsumer };
  };

  const handleVideoLiveLoad = async (peer, consumer, audioConsumer) => {
    const { track } = consumer;
    const { track: audio } = audioConsumer;

    try {
      videoPlayerRef.current.srcObject = new MediaStream([track, audio]);
    } catch (error) {
      console.log(error.message);
    }
    await peer.request('consumerResume');
    await peer.request('audioConsumerResume');
  };

  /**
   * 미디어 서버에 전달되고 있는 실시간 미디어를 가져오기 위해
   * 필요한 정보를 반환하는 함수를 실행하는 함수
   *
   * @param {Object} peer 미디어 서버의 시그널링 서버와 연결된 객체
   */

  const initConsume = async peer => {
    const rptCapabilities = await getRtpCapabilities(peer);
    const consumerDevice = await createConsumeDevice(rptCapabilities);
    const consumerTransport = await createConsumeTransport(peer, consumerDevice);
    const { consumer, audioConsumer } = await connectWithConsumeRouter(
      peer,
      consumerDevice,
      consumerTransport
    );
    await handleVideoLiveLoad(peer, consumer, audioConsumer);

    setConsumer(consumer);
  };

  const isValidRoom = async () => {
    const result = await axios.get(`/room-service/room?roomId=${id}&uuid=${userId}`);
    if (result?.errorCode) {
      navigate('/home');
    }
  };

  useEffect(() => {
    if (isLive && id) {
      isValidRoom();
    }
  }, [id]);

  // 실시간 방송일 경우에만 시그널링 서버에 접속
  useEffect(() => {
    let newPeer = null;
    if (isLive && roomId) {
      const transport = new protooClient.WebSocketTransport(
        `${process.env.REACT_APP_LIVE_SOCKET}/?room=${roomId}&peer=${uuidv4()}&role=consume`
      );
      newPeer = new protooClient.Peer(transport);

      newPeer.on('open', () => {
        initConsume(newPeer);
      });

      newPeer.on('close', () => {
        navigate('/home');
      });

      newPeer.on('notification', notification => {
        switch (notification.method) {
          case 'producerClose': {
            const { message } = notification.data;
            modalService.show(AdviseModal, {
              content: message,
              bntContent: '메인 페이지로 이동',
              onClick: () => {
                newPeer.close();
              },
            });
            break;
          }
          case 'streamUnavailable': {
            modalService.show(AdviseModal, {
              content: '방송이 종료되었습니다.',
              bntContent: '메인 페이지로 이동',
              onClick: () => {
                newPeer.close();
              },
            });
            break;
          }
          default:
            break;
        }
      });
    }

    return () => {
      if (isLive && roomId && newPeer) {
        newPeer.close();
      }
    };
  }, [roomId]);

  return { consumer, peer };
}
