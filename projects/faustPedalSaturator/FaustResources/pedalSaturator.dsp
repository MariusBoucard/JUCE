import("stdfaust.lib");

// Guitar Saturation with 4 macro controls
// =======================================

// UI Parameters
gain = hslider("Gain", 1, 0.1, 4, 0.01);
saturation = hslider("Saturation", 0.5, 0, 1, 0.01);
tone = hslider("Tone", 0.5, 0, 1, 0.01);
character = hslider("Character", 0.5, 0, 1, 0.01);

// Saturation functions
// Soft clipping (smooth, warm)
softClip(x) = x / (1 + abs(x));

// Asymmetric clipping (more harmonics)
asymClip(x) = ba.if(x > 0,
    x / (1 + x),
    x / (1 + abs(x * 1.5)));

// Hard clipping with smoothing
hardClip(x) = max(-0.9, min(0.9, x * 1.1)) : fi.lowpass(1, 8000);

// Tube-like saturation
tubeSat(x) = x * (1 + x*x) / (1 + x*x*2);

// Wavefolder (adds bright harmonics)
wavefold(x) = ba.if(abs(x) > 1,
    2 - abs(x),
    x);

// Pre-emphasis filter (tone control)
// When tone = 0: neutral
// When tone = 1: high boost before saturation
preEmphasis = fi.highshelf(2, 2000, tone * 12);

// Post-saturation tone shaping
// Compensates for high-end loss in saturation
postTone = fi.highshelf(2, 3000, (1-saturation) * 6);

// Multi-stage saturation processor
// Character knob blends between different saturation flavors
satProcessor(x) =
    // Stage 1: Soft saturation (always present)
    softClip(x * (1 + saturation * 2)) * 0.7

    // Stage 2: Character-dependent saturation
    + (characterBlend * asymClip(x * (1 + saturation * 3)) * 0.4)
    + ((1-characterBlend) * tubeSat(x * (1 + saturation * 1.5)) * 0.6)

    // Stage 3: Subtle wavefold for extreme settings
    + (saturation * 0.3 * wavefold(x * saturation * 2))

    with {
        // Character < 0.5: more tube-like
        // Character > 0.5: more asymmetric/aggressive
        characterBlend = max(0, (character - 0.5) * 2);
    };

// Output level compensation
// More saturation = lower output to maintain perceived level
outputComp = 1.0 / (1 + saturation * 0.7);

// Main processing chain
process =
    // Input gain
    _ * gain

    // Pre-emphasis for tone control
    : preEmphasis

    // Saturation stage
    : satProcessor

    // Post-tone shaping
    : postTone

    // Output compensation and final soft limiter
    : (_ * outputComp)
    : softClip;