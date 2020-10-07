import Hls from 'hls.js';

// yes, this is ugly js, but phoenix liveview wants an object with callbacks
// and i'm committed to using liveview in this app as an experiment :)
export default class AudioPlayer {
  mounted() {
    this.handleEvent('started-audio', () => {
      this.el.play();
      this.el.muted = false;
    });

    this.handleEvent('stopped-audio', () => {
      this.el.muted = true;
    });

    if (this.el.canPlayType('application/vnd.apple.mpegurl')) {
      this.el.src = this.el.dataset.src;
      this.el.addEventListener('loadedmetadata', () => this.pushEvent('audio-player-loaded'));
    } else if (Hls.isSupported()) {
      const hls = new Hls();
      hls.loadSource(this.el.dataset.src);
      hls.attachMedia(this.el);
      hls.on(Hls.Events.MANIFEST_PARSED, () => this.pushEvent('audio-player-loaded')); 
    }
  }
}
