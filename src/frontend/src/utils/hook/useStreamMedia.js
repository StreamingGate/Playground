import { useEffect, useState } from 'react';

const constraints = { audio: { echoCancellation: true }, video: { width: 1280, height: 720 } };

export default function useStreamMedia(streamPlayerRef) {
  const [stream, setStream] = useState({ videoTrack: null, audioTrack: null });

  async function getMediaStream() {
    try {
      const newStream = await navigator.mediaDevices.getUserMedia(constraints);
      const videoDom = streamPlayerRef.current;

      videoDom.srcObject = newStream;
      videoDom.onloadedmetadata = () => {
        videoDom.play();
      };

      setStream({
        videoTrack: newStream.getVideoTracks()[0],
        audioTrack: newStream.getAudioTracks()[0],
      });
    } catch (err) {
      console.log(err.message);
    }
  }

  useEffect(() => {
    getMediaStream();
  }, []);

  return stream;
}
