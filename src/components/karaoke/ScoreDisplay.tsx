import React, { useEffect, useState } from "react";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import { motion, AnimatePresence } from "framer-motion";

interface ScoreDisplayProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  score: number;
  accuracy: number;
  message?: string;
}

const ScoreDisplay = ({
  open,
  onOpenChange,
  score = 85,
  accuracy = 90,
  message = "Boa performance!",
}: ScoreDisplayProps) => {
  const [autoClose, setAutoClose] = useState<NodeJS.Timeout>();

  useEffect(() => {
    if (open) {
      const timer = setTimeout(() => {
        onOpenChange(false);
      }, 5000);
      setAutoClose(timer);
    }
    return () => {
      if (autoClose) clearTimeout(autoClose);
    };
  }, [open, onOpenChange]);

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-gray-900/95 border-none">
        <AnimatePresence>
          {open && (
            <motion.div
              initial={{ scale: 0.8, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.8, opacity: 0 }}
              className="text-center p-6"
            >
              <motion.div
                initial={{ scale: 0.8, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                transition={{ type: "spring", duration: 0.8 }}
                className="text-8xl mb-6"
              >
                {score >= 90
                  ? "🌟"
                  : score >= 80
                    ? "🎉"
                    : score >= 70
                      ? "🎵"
                      : score >= 60
                        ? "👏"
                        : "💪"}
              </motion.div>
              <motion.h2
                initial={{ y: 20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: 0.3 }}
                className="text-6xl font-bold text-primary mb-4"
              >
                {score}
              </motion.h2>
              <motion.div
                initial={{ y: 20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: 0.5 }}
                className="text-2xl text-white mb-6"
              >
                {message}
              </motion.div>
              <motion.div
                initial={{ y: 20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: 0.7 }}
                className="text-xl text-muted-foreground"
              >
                Precisão: {accuracy}%
              </motion.div>
            </motion.div>
          )}
        </AnimatePresence>
      </DialogContent>
    </Dialog>
  );
};

export default ScoreDisplay;
