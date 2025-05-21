# Performances

## NAM

Nam was running slow, but still running in release. It's not the case anoymore, something broke in the config.

Should we use VTune to understand what's going on ? 
To do so we'll need to be able to debug through the libraries (should we add the juce debug flags ?)

-> Performances Issues comming from Eigen, not able to fix it. Perhaps comes from bad compilor optimisations and flags ? 
-> VTune underlined that issue was comming from eigen computation