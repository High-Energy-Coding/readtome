import './main.css';
import { Elm } from './Main.elm';
//import * as serviceWorker from './serviceWorker';

var app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: window.location.pathname
});

//serviceWorker.unregister();

let audioEl;

app.ports.initAudioEl.subscribe(() => {
    audioEl = document.querySelector("audio");
    audioEl.onplay = () => { app.ports.playing.send(true); };
    audioEl.onpause = () => { app.ports.pausing.send(true); };
})

app.ports.play.subscribe(() => {
    audioEl.play();
})
app.ports.pause.subscribe(() => {
    audioEl.pause();
})

