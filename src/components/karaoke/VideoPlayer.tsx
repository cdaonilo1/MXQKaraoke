import React, { useState } from "react";
import { Slider } from "@/components/ui/slider";
import { Button } from "@/components/ui/button";
import {
  Volume2,
  VolumeX,
  Music2,
  SkipForward,
  SkipBack,
  Play,
  Pause,
} from "lucide-react";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip";

interface VideoPlayerProps {
  videoUrl?: string;
  onNext?: () => void;
  onPrevious?: () => void;
  onPlayPause?: () => void;
  isPlaying?: boolean;
  onEnded?: () => void;
}

const VideoPlayer = ({
  videoUrl = "https://example.com/sample-video.mp4",
  onNext = () => {},
  onPrevious = () => {},
  onPlayPause = () => {},
  isPlaying = false,
  onEnded = () => {},
}: VideoPlayerProps) => {
  const [volume, setVolume] = useState([75]);
  const [pitch, setPitch] = useState([0]);

  // Musical notes array for reference
  const notes = [
    "C",
    "C#",
    "D",
    "D#",
    "E",
    "F",
    "F#",
    "G",
    "G#",
    "A",
    "A#",
    "B",
  ];

  // Function to get the note name based on pitch shift
  const getCurrentNote = (pitchShift: number) => {
    // Base note is C (0)
    const noteIndex = ((pitchShift % 12) + 12) % 12; // Ensure positive index
    return notes[noteIndex];
  };
  const [isMuted, setIsMuted] = useState(false);
  const videoRef = React.useRef<HTMLVideoElement>(null);
  const audioContextRef = React.useRef<AudioContext>();
  const sourceNodeRef = React.useRef<MediaElementAudioSourceNode>();
  const pitchNodeRef = React.useRef<any>();

  // Initialize Web Audio API
  React.useEffect(() => {
    const setupAudio = async () => {
      try {
        // Create audio context if it doesn't exist
        if (!audioContextRef.current) {
          audioContextRef.current = new (window.AudioContext ||
            (window as any).webkitAudioContext)();
        }

        // Resume audio context if it's suspended
        if (audioContextRef.current.state === "suspended") {
          await audioContextRef.current.resume();
        }

        if (
          videoRef.current &&
          audioContextRef.current &&
          !sourceNodeRef.current
        ) {
          // Create source node only if it doesn't exist
          sourceNodeRef.current =
            audioContextRef.current.createMediaElementSource(videoRef.current);

          // Create pitch shifter node
          const pitchShifter = audioContextRef.current.createScriptProcessor(
            4096,
            1,
            1,
          );
          pitchShifter.onaudioprocess = (e) => {
            const input = e.inputBuffer.getChannelData(0);
            const output = e.outputBuffer.getChannelData(0);
            const pitchShift = Math.pow(2, pitch[0] / 12);

            for (let i = 0; i < input.length; i++) {
              const index = Math.floor(i * pitchShift);
              output[i] = index < input.length ? input[index] : 0;
            }
          };

          // Connect nodes
          sourceNodeRef.current
            .connect(pitchShifter)
            .connect(audioContextRef.current.destination);

          pitchNodeRef.current = pitchShifter;
        }
      } catch (error) {
        console.error("Error setting up audio:", error);
      }
    };

    setupAudio();

    return () => {
      if (pitchNodeRef.current) {
        pitchNodeRef.current.disconnect();
        pitchNodeRef.current = null;
      }
    };
  }, []);

  // Update pitch effect when pitch changes
  React.useEffect(() => {
    if (pitchNodeRef.current && audioContextRef.current) {
      pitchNodeRef.current.onaudioprocess = (e) => {
        const input = e.inputBuffer.getChannelData(0);
        const output = e.outputBuffer.getChannelData(0);
        const pitchShift = Math.pow(2, pitch[0] / 12);

        for (let i = 0; i < input.length; i++) {
          const index = Math.floor(i * pitchShift);
          output[i] = index < input.length ? input[index] : 0;
        }
      };
    }
  }, [pitch]);

  // Handle T key press
  React.useEffect(() => {
    const handleKeyPress = (e: KeyboardEvent) => {
      if (e.key.toLowerCase() === "t") {
        setPitch((prev) => [prev[0] >= 11 ? -12 : prev[0] + 1]);
      }
    };

    window.addEventListener("keydown", handleKeyPress);
    return () => window.removeEventListener("keydown", handleKeyPress);
  }, []);

  const handlePitchChange = (newPitch: number[]) => {
    setPitch(newPitch);
    // Here you would implement the actual pitch shifting
    // This would depend on your video player implementation
    console.log("Pitch changed to:", newPitch[0], "semitones");
  };

  React.useEffect(() => {
    if (videoRef.current) {
      if (isPlaying) {
        videoRef.current.play();
      } else {
        videoRef.current.pause();
      }
    }
  }, [isPlaying]);

  React.useEffect(() => {
    if (videoRef.current) {
      videoRef.current.volume = volume[0] / 100;
      videoRef.current.muted = isMuted;
    }
  }, [volume, isMuted]);

  return (
    <div className="w-full h-[700px] bg-black/95 flex flex-col relative">
      {/* Video Display Area */}
      <div className="flex-1 bg-black">
        <video
          ref={videoRef}
          className="w-full h-full object-contain"
          src={videoUrl}
          controls={false}
          autoPlay
          onEnded={onEnded}
        />
      </div>

      {/* Controls Bar */}
      <div className="bg-gray-900 p-4 flex items-center gap-4 justify-between">
        <div className="flex items-center gap-4">
          <TooltipProvider>
            {/* Playback Controls */}
            <div className="flex items-center gap-2">
              <Tooltip>
                <TooltipTrigger asChild>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={onPrevious}
                    className="text-white hover:text-primary"
                  >
                    <SkipBack className="h-6 w-6" />
                  </Button>
                </TooltipTrigger>
                <TooltipContent>
                  <p>Previous Song</p>
                </TooltipContent>
              </Tooltip>

              <Tooltip>
                <TooltipTrigger asChild>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={onPlayPause}
                    className="text-white hover:text-primary"
                  >
                    {isPlaying ? (
                      <Pause className="h-6 w-6" />
                    ) : (
                      <Play className="h-6 w-6" />
                    )}
                  </Button>
                </TooltipTrigger>
                <TooltipContent>
                  <p>{isPlaying ? "Pause" : "Play"}</p>
                </TooltipContent>
              </Tooltip>

              <Tooltip>
                <TooltipTrigger asChild>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={onNext}
                    className="text-white hover:text-primary"
                  >
                    <SkipForward className="h-6 w-6" />
                  </Button>
                </TooltipTrigger>
                <TooltipContent>
                  <p>Next Song</p>
                </TooltipContent>
              </Tooltip>
            </div>

            {/* Volume Control */}
            <div className="flex items-center gap-2 w-48">
              <Tooltip>
                <TooltipTrigger asChild>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => setIsMuted(!isMuted)}
                    className="text-white hover:text-primary"
                  >
                    {isMuted ? (
                      <VolumeX className="h-6 w-6" />
                    ) : (
                      <Volume2 className="h-6 w-6" />
                    )}
                  </Button>
                </TooltipTrigger>
                <TooltipContent>
                  <p>{isMuted ? "Unmute" : "Mute"}</p>
                </TooltipContent>
              </Tooltip>
              <Slider
                value={volume}
                onValueChange={setVolume}
                max={100}
                step={1}
                className="w-32"
              />
            </div>

            {/* Pitch Control */}
            <div className="flex items-center gap-2 w-48">
              <Tooltip>
                <TooltipTrigger asChild>
                  <Button
                    variant="ghost"
                    size="icon"
                    className="text-white hover:text-primary"
                  >
                    <Music2 className="h-6 w-6" />
                  </Button>
                </TooltipTrigger>
                <TooltipContent>
                  <p>Pitch Control</p>
                </TooltipContent>
              </Tooltip>
              <Slider
                value={pitch}
                onValueChange={handlePitchChange}
                min={-12}
                max={12}
                step={1}
                className="w-32"
              />
            </div>
          </TooltipProvider>
        </div>

        {/* Pitch Display */}
        <div className="flex items-center gap-2">
          <span className="text-sm text-yellow-500">Tom:</span>
          <span className="font-mono bg-yellow-500/20 px-2 py-1 rounded text-yellow-500 border border-yellow-500/30">
            {getCurrentNote(pitch[0])} (
            {pitch[0] >= 0 ? `+${pitch[0]}` : pitch[0]})
          </span>
          <span className="text-xs text-yellow-500/70">
            (Pressione T para mudar)
          </span>
        </div>
      </div>
    </div>
  );
};

export default VideoPlayer;
