import React from "react";
import { ScrollArea } from "../ui/scroll-area";
import { Button } from "../ui/button";
import { X, Music2 } from "lucide-react";

interface QueueItem {
  id: string;
  code: string;
  title: string;
  artist: string;
}

interface QueueDisplayProps {
  queue?: QueueItem[];
  currentBalance?: number;
  onRemoveItem?: (id: string) => void;
}

const QueueDisplay = ({
  queue = [
    { id: "1", code: "12345", title: "Sweet Caroline", artist: "Neil Diamond" },
    { id: "2", code: "67890", title: "Bohemian Rhapsody", artist: "Queen" },
    { id: "3", code: "11111", title: "Yesterday", artist: "The Beatles" },
  ],
  onRemoveItem = () => {},
}: QueueDisplayProps) => {
  if (queue.length === 0) return null;

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-black/90 backdrop-blur-sm border-t border-gray-800">
      <div className="container mx-auto px-4 py-2">
        <div className="flex items-center gap-4 overflow-x-auto whitespace-nowrap scrollbar-hide">
          <div className="flex-none py-2 px-3 bg-yellow-500/20 rounded-md border border-yellow-500/30">
            <span className="text-yellow-500 font-semibold">Próximas:</span>
          </div>
          {queue.map((item, index) => (
            <div
              key={item.id}
              className="flex-none group py-2 px-3 bg-gray-800/50 rounded-md border border-gray-700/50 flex items-center gap-3"
            >
              <div className="flex items-center gap-2">
                <Music2 className="w-4 h-4 text-primary" />
                <span className="text-white/70 text-sm">{index + 1}.</span>
              </div>
              <div className="flex flex-col">
                <p className="text-sm font-medium text-white">{item.title}</p>
                <p className="text-xs text-gray-400">{item.artist}</p>
              </div>
              <Button
                variant="ghost"
                size="icon"
                onClick={() => onRemoveItem(item.id)}
                className="h-6 w-6 opacity-0 group-hover:opacity-100 transition-opacity"
              >
                <X className="h-3 w-3 text-gray-400" />
              </Button>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default QueueDisplay;
