

// a simple synthdef
(
SynthDef(\am, {
	arg f0 = 100, f1 = 200, gain = 1, pan = 0, out = 0, amp = 1,
	at = 1, sus = 1, rel = 1;
	var sig, carrier, env;
	env = EnvGen.ar(Env.linen(at, sus, rel), 1, doneAction:2);
	sig = SinOsc.ar(f0*env.range(1, 1.01));
	carrier = SinOsc.ar(f1*env.range(0.99, 1), mul: gain*env);
	sig = sig*carrier;
	sig = sig*env;
	sig = Pan2.ar(sig, pan);
	sig = sig*amp*f0.expexp(20, 20000, 1, 0.1);
	Out.ar(out, sig);
}).add;
)

///////////////
//some examples

//the very basic harmonic staircase
(
Ndef(\y)[0] = Tdef(\am, {
    loop({
		var density = 40,
		tempo  =  1;
	{
	density.do({
	arg i;
	var
	freq = 100*i,
	mod = 200*i,
	gain = 0.1,
	gap = 0.1,
	amp = exprand(1, 0.1),
	rel = 0.001*i,
	at = 1,
	sus = 0.01*i,
	out = 0,
	pan = rrand(-1.0, 1.0);
	Synth(\am,
	            [\f0, mod, \f1, freq, \pan, pan, \amp, amp, \at, at, \sus, sus, \rel, rel, \gain, gain, \out, out]
				);
	gap.wait;
		})
		}.fork;
        tempo.wait;
    })
})
)

//free
Ndef(\y).free;

//more complex fast itteration with linear functions and randomnes
(
Ndef(\y)[0] = Tdef(\y, {
    loop({
		var density = 60,
		tempo  =  0.1;
	{
	density.do({
	arg i;
	var
	mod = 200*(i*[1, 1.1].choose),
	freq = 30*(1*i+0),
	gain = 0.1,
	gap = 0.001*i,
	amp = exprand(1, 0.1),
	rel = [0.1, 0.01].choose,
	at = 0.1,
	sus = 0.01,
	out = 0,
	pan = rrand(-1.0, 1.0);
	Synth(\am,
	            [\f0, mod, \f1, freq, \pan, pan, \amp, amp, \at, at, \sus, sus, \rel, rel, \gain, gain, \out, out]
				);
	gap.wait;
		})
		}.fork;
        tempo.wait;
    })
})
)

Ndef(\y).free;

//aliasing
(
Ndef(\y)[0] = Tdef(\y, {
	loop({
	var density = [5, 30].wchoose([0.6, 0.4]),
	list = [10, 800, 700, 100, 30].resamp1(density),
	position = [-1, 1, -1].resamp1(density),
	tempo = 2;

	{
	density.do({
	arg i;
	var
	mod = (i*2)*(((-3)*((i-density) + 1)) * (3*i+1)),
	freq = 100,
	gain = 0.1,
	gap = 0.1,
	amp = exprand(1.0,0.1),
	rel = 1,
	at = 1,
	sus = 0.1,
	pan = 0,
	out = 0;

	freq = list[i];
	pan = position[i];

	Synth(\am,
	            [\f0, mod, \f1, freq, \pan, pan, \amp, amp, \at, at, \sus, sus, \rel, rel, \gain, gain, \out, out]
				);
	gap.wait;
		});
		}.fork;
	  tempo.wait;
	});
});
)

Ndef(\y).free;

//sweep
(
Ndef(\y)[0] = Tdef(\y, {
	loop({
	var density = 20,
	root = 900,
	attack = [0.01, 1].wchoose([0.3, 0.7]),
	direction = root*[0.1, 1, 0.75].choose,
	c = [1, 2, 3, 4, 10].choose,
	tempo = 2;

    {
	density.do({
	arg i;
	var
	rate = root*(c+(i*0.01)),
	mod = direction*((density-i)),
	gain = 0.1,
	gap = 0.1,
	amp = 1,
	rel = 1,
	at = attack,
	sus = 0.1,
	pan = (2*(i/density)+(-1)),
	out = 0;
	Synth(\am,
					[\f0, rate, \f1, mod, \pan, pan, \amp, amp, \at, at, \sus, sus, \rel, rel, \gain, gain, \out, out]
				);
	gap.wait;
		});
		}.fork;

		tempo.wait;
});
})
)

Ndef(\y).free;


//some sort of a string
(
Ndef(\y)[0] = Tdef(\y, {
	loop({
	var density = 100,
	root = [43, 42, 49].midicps.wchoose([0.4, 0.4, 0.2]),
	tempo = [1/4, 1/2].choose;

	{
	density.do({
	arg i;
	var
	c = rrand(1.0, 1.02),
	rate = root*(density-i),
	mod = root*(density-i)*c,
	gain = 0.1,
	gap = 0.001,
	amp = exprand(1, 0.1),
	at = 0.001*i,
	rel = 0.01*(i*[0.7, 2].choose),
	sus = 0.1,
	pan = rrand(-1.0, 1.0),
	out = 0;
				Synth(\am,
					[\f0, rate, \f1, mod, \pan, pan, \amp, amp, \at, at, \sus, sus, \rel, rel, \gain, gain, \out, out]
				);
	gap.wait;
		})
		}.fork;
	tempo.wait;
})
});
)

Ndef(\y).free;

//nice artifacts
(
Ndef(\y)[0] = Tdef(\y, {
    loop({
		var density = 40,
		tempo  =  [0.5, 0.1].choose;
	{
	density.do({
	arg i;
	var
	mod = 1*(((-3)*((i-density) + 6)) * (3*i+3)),
	freq = [12, 10, 2].choose*(3*i+2)*(i*0.01),
	gain = 0.1,
	gap = rrand(0.001, 0.0001)*i,
	amp = exprand(1, 0.6),
	rel = [0.1, 0.01].choose,
	at = [0.0001, 0.005].choose*i,
	sus = 0.0001*i,
	out = 0,
	pan = (2*(i/density)+(-1))*[1, -1].choose*1;
	Synth(\am,
	            [\f0, mod, \f1, freq, \pan, pan, \amp, amp, \at, at, \sus, sus, \rel, rel, \gain, gain, \out, out]
				);
	gap.wait;
		})
		}.fork;
        tempo.wait;
    })
})
)

Ndef(\y).free;

//a bit jazzy
(
Ndef(\y)[0] = Tdef(\y, {
	 loop({
	var density = [10, 20, 40, 80].choose,
	root = 100,
	c = 1,
	flist = [[200, 300, 60, 600, 80].resamp0(density), [300, 60, 600, 80].resamp0(density).reverse].choose,
	clist = [1.8, 2, 3/4, 3].resamp0(density)*[1, 0.5].choose,
	at = [0.1, 0.01, 0.2].choose,
	tempo = 3;

	{
	density.do({
	arg i;
	var
	rate = root,
	mod = root*c,
	gain = 0.1,
	gap = rrand(0.01, 0.1),
	amp = 1,
	rel = 0.1,
	sus = 0.1,
	pan = (i/density)*[-1, 1].choose*0.5,
	out = 0;
	c = clist[i];
	root = flist[i];
				Synth(\am,
					[\f0, rate, \f1, mod, \pan, pan, \amp, amp, \at, at, \sus, sus, \rel, rel, \gain, gain, \out, out]
				);
	gap.wait;
		})
		}.fork;
    tempo.wait;
    })
})
)

Ndef(\y).free;