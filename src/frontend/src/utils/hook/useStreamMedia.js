import { useEffect, useState } from 'react';

let constraints = null;

export default function useStreamMedia(streamPlayerRef, device = 'web') {
  const [stream, setStream] = useState({ videoTrack: null, audioTrack: null });
  const [facingMode, setFacingMode] = useState('user');

  async function getMediaStream(facingMode = 'user') {
    try {
      if (device === 'mobile') {
        constraints = {
          audio: { echoCancellation: false },
          video: { facingMode: `${facingMode}` },
        };
      } else {
        constraints = {
          audio: { echoCancellation: false },
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
  }

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

  const switchCamera = async () => {
    if (facingMode === 'user') {
      await getMediaStream('environment');
      setFacingMode('environment');
    } else {
      setFacingMode('user');
      await getMediaStream('user');
    }
  };

  return { stream, toggleMuteAudio, stopStream, switchCamera };
}
