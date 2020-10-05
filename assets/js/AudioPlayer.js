import Hls from 'hls.js';

const AudioPlayer = (element) => {
  const src = element.dataset.src;
  if (element.canPlayType('application/vnd.apple.mpegurl')) {
    element.src = src;
    element.addEventListener('loadedmetadata', () => element.play());
  } else if (Hls.isSupported()) {
    const hls = new Hls({debug: true});
    hls.loadSource(src);
    hls.attachMedia(element);
    hls.on(Hls.Events.MANIFEST_PARSED, () => element.play());
  }
};

export default AudioPlayer;
