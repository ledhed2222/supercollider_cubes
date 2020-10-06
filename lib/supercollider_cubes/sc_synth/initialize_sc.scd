// Boots scsynth and creates a synth
s.options.outDevice = "BlackHole 16ch";
s.waitForBoot({
  var message;
  ~synth = Synth.basicNew(\grains, s);
  message = ~synth.newMsg(s, \addToTail);
  SynthDef(\grains, { |out, freq=440, pan=0|
    Out.ar(out, GrainSin.ar(2, Impulse.kr(10), 0.1, freq, pan, -1));
  }).send(s, message);
});
