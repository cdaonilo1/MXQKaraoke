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
  const [isMuted, setIsMuted] = useState(false);
  const videoRef = React.useRef<HTMLVideoElement>(null);

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
      <div className="bg-gray-900 p-4 flex items-center gap-4">
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
    </div>
  );
};

export default VideoPlayer;
