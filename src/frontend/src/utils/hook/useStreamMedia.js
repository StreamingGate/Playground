import { useEffect, useState } from 'react';

const constraints = {
  audio: { echoCancellation: false },
  // video: { width: 1280, height: 720 },
};

export default function useStreamMedia(streamPlayerRef, device = 'web') {
  const [stream, setStream] = useState({ videoTrack: null, audioTrack: null });

  async function getMediaStream() {
    try {
      // iphone 접근시 constraints 동적으로 변경
      if (device === 'mobile') {
        // constraints.video = { ...constraints.video, facingMode: 'user' };
      }

      const newStream = await navigator.mediaDevices.getUserMedia({
        audio: { echoCancellation: false },
        video: { facingMode: 'user' },
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

  const switchCamera = () => {
    const constraints = stream.videoTrack.getConstraints();
    if (constraints.facingMode === 'user') {
      constraints.facingMode = { exact: 'environment' };
    } else {
      constraints.facingMode = 'user';
    }

    stream.videoTrack.applyConstraints(constraints);
  };

  return { stream, toggleMuteAudio, stopStream, switchCamera };
}
