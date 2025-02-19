import React from "react";
import { Card } from "@/components/ui/card";
import { Music, User, Code } from "lucide-react";

interface InfoBarProps {
  songCode?: string;
  artist?: string;
  title?: string;
  firstLyric?: string;
}

const InfoBar = ({
  songCode = "12345",
  artist = "Unknown Artist",
  title = "Untitled Song",
  firstLyric = "First line of lyrics will appear here...",
}: InfoBarProps) => {
  return (
    <Card className="w-full h-20 bg-background/95 backdrop-blur fixed bottom-0 left-0 right-0 border-t">
      <div className="flex items-center justify-between h-full px-6">
        <div className="flex items-center space-x-6">
          <div className="flex items-center space-x-2">
            <Code className="w-5 h-5 text-primary" />
            <span className="text-lg font-medium">{songCode}</span>
          </div>

          <div className="flex items-center space-x-2">
            <User className="w-5 h-5 text-primary" />
            <span className="text-lg">{artist}</span>
          </div>

          <div className="flex items-center space-x-2">
            <Music className="w-5 h-5 text-primary" />
            <span className="text-lg font-medium">{title}</span>
          </div>
        </div>

        <div className="flex-1 ml-6 overflow-hidden">
          <p className="text-lg text-muted-foreground truncate">{firstLyric}</p>
        </div>
      </div>
    </Card>
  );
};

export default InfoBar;
