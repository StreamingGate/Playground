import { useEffect, useState } from 'react';

const constraints = {
  audio: { echoCancellation: false },
  // video: { width: 1280, height: 720 },
};

export default function useStreamMedia(streamPlayerRef, device = 'web') {
  const [stream, setStream] = useState({ videoTrack: null, audioTrack: null });
  const [facingMode, setFacingMode] = useState('user');

  async function getMediaStream(facingMode = 'user') {
    try {
      // iphone 접근시 constraints 동적으로 변경
      if (device === 'mobile') {
        // constraints.video = { ...constraints.video, facingMode: 'user' };
      }

      const newStream = await navigator.mediaDevices.getUserMedia({
        audio: { echoCancellation: false },
        video: { facingMode: `${facingMode}` },
      });
      const videoDom = streamPlayerRef.current;

      videoDom.srcObject = newStream;
      // videoDom.onloadedmetadata = () => {
      //   videoDom.play();
      // };

      setStream({
        videoTrack: newStream.getVideoTracks()[0],
        audioTrack: newStream.getAudioTracks()[0],
      });
    } catch (err) {
      alert(err);
      console.log(err.message);
    }
  }

  useEffect(() => {
    getMediaStream();
  }, []);

  const toggleMuteAudio = () => {
    const curAudioEnable = stream.audioTrack.enabled;
    stream.audioTrack.enabled = !curAudioEnable;
  };

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

  const switchCamera = async () => {
    if (facingMode === 'user') {
      await getMediaStream('environment');
      setFacingMode('environment');
    } else {
      setFacingMode('user');
      await getMediaStream('user');
    }
    // const constraints = stream.videoTrack.getConstraints();
    // console.log('!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // alert(JSON.stringify(constraints));
    // console.log(constraints);
    // console.log('!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // if (constraints.facingMode === 'user') {
    //   constraints.facingMode = { exact: 'environment' };
    // } else {
    //   constraints.facingMode = 'user';
    // }
    // console.log('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    // alert(JSON.stringify(constraints));
    // console.log(constraints);
    // console.log('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    // stream.videoTrack
    //   .applyConstraints(constraints)
    //   .then(() => {
    //     console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    //     alert(JSON.stringify(stream.videoTrack.getConstraints()));
    //     console.log(stream.videoTrack.getConstraints());
    //     console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    //     // Do something with the track such as using the Image Capture API.
    //   })
    //   .catch(e => {
    //     alert(e.message);
    //     // The constraints could not be satisfied by the available devices.
    //   });
  };

  return { stream, toggleMuteAudio, stopStream, switchCamera };
}
