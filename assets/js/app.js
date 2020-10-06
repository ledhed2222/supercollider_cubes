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

const Hooks = {
  PhysicsCanvas: new PhysicsCanvas(),
  AudioPlayer: new AudioPlayer(),
};

const csrfToken = window.document.querySelector('meta[name=\'csrf-token\']').getAttribute('content');
const liveSocket = new LiveSocket('/live', Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}});

// Show progress bar on live navigation and form submits
window.addEventListener('phx:page-loading-start', (info) => NProgress.start());
window.addEventListener('phx:page-loading-stop', (info) => NProgress.done());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket;
