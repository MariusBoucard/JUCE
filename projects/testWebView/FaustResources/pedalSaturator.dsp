import("stdfaust.lib");

drive = hslider("drive [unit:dB]", 0, 0, 40, 0.1);
mix   = hslider("mix", 0.5, 0, 1, 0.01);

drive_lin = ba.db2linear(drive);

saturator(x) = ma.tanh(x);

sat(x) = x <: (_, saturator(_ * drive_lin))
          :> (_,_) : *(1 - mix), *(mix) : +;

// Apply to 2 channels
process = sat, sat;