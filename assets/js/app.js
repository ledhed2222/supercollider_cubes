// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.scss';

import 'phoenix_html';
import { Socket } from 'phoenix';
import NProgress from 'nprogress';
import { LiveSocket } from 'phoenix_live_view';

import PhysicsCanvas from './PhysicsCanvas';
import AudioPlayer from './AudioPlayer';

const csrfToken = window.document.querySelector('meta[name=\'csrf-token\']').getAttribute('content');
const liveSocket = new LiveSocket('/live', Socket, {params: {_csrf_token: csrfToken}});

const userSocket = new Socket('/socket');

// Show progress bar on live navigation and form submits
window.addEventListener('phx:page-loading-start', (info) => NProgress.start());
window.addEventListener('phx:page-loading-stop', (info) => NProgress.done());

// connect if there are any LiveViews on the page
liveSocket.connect();
userSocket.connect();
const userChannel = userSocket.channel('sc:sup', {}).join();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket;
window.userChannel = userChannel;

// Render canvas
const physicsCanvasRoot = window.document.getElementById('canvas-root');
if (physicsCanvasRoot) {
  PhysicsCanvas(physicsCanvasRoot);
}

// Render audio
const audioRoot = window.document.getElementById('audio-root');
if (audioRoot) {
  AudioPlayer(audioRoot);
}
