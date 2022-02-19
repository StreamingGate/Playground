import { useEffect, useState } from 'react';

let constraints = null;

/**
 * @param {Object} streamPlayerRef video dom ref
 * @param {string} device 미디어 스트림을 재생시킬 디바이스 타입
 * @returns
 * stream: 로컬 미디어 스트림
 * toggleMuteAudio: 오디오 스트림 음소거 토글 함수
 * stopSteam: 미디어 스트림 정지 함수
 * switchCamera: 모바일 전/후면 카메라 전환
 */

export default function useStreamMedia(streamPlayerRef, device = 'web') {
  const [stream, setStream] = useState({ videoTrack: null, audioTrack: null });
  const [facingMode, setFacingMode] = useState('user');
  const [pcMode, setPCMode] = useState('default');

  const stopStream = () => {
    const { videoTrack, audioTrack } = stream;

    if (videoTrack) {
      videoTrack.stop();
    }
    if (audioTrack) {
      audioTrack.stop();
    }

    streamPlayerRef.current.srcObject = null;
    setStream({ videoTrack: null, audioTrack: null });
  };

  // 디바이스 미디어 스트림 접근
  const getMediaStream = async (facingMode = 'user') => {
    try {
      stopStream();
      // 접속하는 디바이스가 모바일일 경우 전면 카메라로 방송시작
      if (device === 'mobile') {
        constraints = {
          audio: { echoCancellation: false, channelCount: 2 },
          video: { facingMode: `${facingMode}` },
        };
      } else {
        constraints = {
          audio: { echoCancellation: false, channelCount: 2 },
          video: { width: 1280, height: 720 },
        };
      }

      const newStream = await navigator.mediaDevices.getUserMedia(constraints);
      const videoDom = streamPlayerRef.current;

      videoDom.srcObject = newStream;

      setStream({
        videoTrack: newStream.getVideoTracks()[0],
        audioTrack: newStream.getAudioTracks()[0],
      });
    } catch (err) {
      console.log(err.message);
    }
  };

  // 화면공유 미디어 스트림 제어
  const getDeviceStream = async () => {
    try {
      stopStream();
      const displayStream = await navigator.mediaDevices.getDisplayMedia({
        audio: { echoCancellation: false, channelCount: 2 },
        video: { width: 1280, height: 720 },
      });
      const newStream = await navigator.mediaDevices.getUserMedia(constraints);

      const videoDom = streamPlayerRef.current;
      videoDom.srcObject = displayStream;

      displayStream.getTracks()[0].onended = async () => {
        await getMediaStream();
        setPCMode('default');
      };

      setStream({
        audioTrack: newStream.getAudioTracks()[0],
        videoTrack: displayStream.getTracks()[0],
      });
    } catch (err) {
      console.log(err.message);
    }
  };

  // 화면 공유, 디바이스 카메라 전환
  const switchPCMedia = async () => {
    if (pcMode === 'default') {
      await getDeviceStream();
      setPCMode('screen');
    } else if (pcMode === 'screen') {
      await getMediaStream();
      setPCMode('default');
    }
  };

  useEffect(() => {
    getMediaStream();
  }, []);

  useEffect(() => {
    return () => {
      if (stream.videoTrack || stream.audioTrack) {
        stopStream();
      }
    };
  }, [stream]);

  const toggleMuteAudio = () => {
    const curAudioEnable = stream.audioTrack.enabled;
    stream.audioTrack.enabled = !curAudioEnable;
  };

  // 모바일 전/후면 카메라 전환
  const switchCamera = async () => {
    if (facingMode === 'user') {
      await getMediaStream('environment');
      setFacingMode('environment');
    } else {
      setFacingMode('user');
      await getMediaStream('user');
    }
  };

  return { stream, toggleMuteAudio, stopStream, switchCamera, switchPCMedia };
}
