import React from "react";
import { ScrollArea } from "../ui/scroll-area";
import { Card } from "../ui/card";
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
  currentBalance = 10,
  onRemoveItem = () => {},
}: QueueDisplayProps) => {
  return (
    <Card className="w-[400px] h-[600px] bg-background border-border p-4 flex flex-col">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-xl font-semibold text-foreground">Queue</h2>
        <div className="text-sm text-muted-foreground">
          Credits: {currentBalance}
        </div>
      </div>

      <ScrollArea className="flex-1">
        <div className="space-y-2">
          {queue.map((item) => (
            <Card
              key={item.id}
              className="p-3 flex items-center justify-between bg-card hover:bg-accent/50 transition-colors"
            >
              <div className="flex items-center gap-3">
                <Music2 className="w-5 h-5 text-primary" />
                <div>
                  <p className="font-medium text-sm text-foreground">
                    {item.title}
                  </p>
                  <p className="text-xs text-muted-foreground">{item.artist}</p>
                  <p className="text-xs text-muted-foreground">
                    Code: {item.code}
                  </p>
                </div>
              </div>
              <Button
                variant="ghost"
                size="icon"
                onClick={() => onRemoveItem(item.id)}
                className="h-8 w-8"
              >
                <X className="h-4 w-4" />
              </Button>
            </Card>
          ))}
        </div>
      </ScrollArea>

      {queue.length === 0 && (
        <div className="flex-1 flex items-center justify-center text-muted-foreground">
          No songs in queue
        </div>
      )}
    </Card>
  );
};

export default QueueDisplay;
