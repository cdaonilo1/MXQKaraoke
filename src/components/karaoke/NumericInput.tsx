import React, { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { motion } from "framer-motion";

interface NumericInputProps {
  onSubmit?: (code: string) => void;
  maxLength?: number;
  isLoading?: boolean;
}

const NumericInput = ({
  onSubmit = () => {},
  maxLength = 5,
  isLoading = false,
}: NumericInputProps) => {
  const [inputValue, setInputValue] = useState("");

  const handleNumberClick = (number: string) => {
    if (inputValue.length < maxLength) {
      setInputValue((prev) => prev + number);
    }
  };

  const handleDelete = () => {
    setInputValue((prev) => prev.slice(0, -1));
  };

  const handleClear = () => {
    setInputValue("");
  };

  const handleSubmit = () => {
    if (inputValue.length === maxLength) {
      onSubmit(inputValue);
      setInputValue("");
    }
  };

  const numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];

  return (
    <Card className="w-[600px] p-6 bg-transparent border-none shadow-none">
      <div className="flex flex-col h-full gap-4">
        <div className="flex justify-center items-center h-20 bg-gray-800/50 rounded-lg text-4xl font-bold tracking-widest text-white mb-8">
          {inputValue.padEnd(maxLength, "_")}
        </div>

        <div className="grid grid-cols-3 gap-2 flex-1">
          {numbers.slice(0, 9).map((num) => (
            <motion.div key={num} whileTap={{ scale: 0.95 }}>
              <Button
                variant="ghost"
                className="w-full h-full text-2xl text-white hover:bg-gray-800/50"
                onClick={() => handleNumberClick(num)}
                disabled={isLoading}
              >
                {num}
              </Button>
            </motion.div>
          ))}
          <motion.div whileTap={{ scale: 0.95 }}>
            <Button
              variant="outline"
              className="w-full h-full text-2xl text-destructive"
              onClick={handleClear}
              disabled={isLoading}
            >
              C
            </Button>
          </motion.div>
          <motion.div whileTap={{ scale: 0.95 }}>
            <Button
              variant="outline"
              className="w-full h-full text-2xl"
              onClick={() => handleNumberClick("0")}
              disabled={isLoading}
            >
              0
            </Button>
          </motion.div>
          <motion.div whileTap={{ scale: 0.95 }}>
            <Button
              variant="outline"
              className="w-full h-full text-2xl text-yellow-500"
              onClick={handleDelete}
              disabled={isLoading}
            >
              ←
            </Button>
          </motion.div>
        </div>

        <motion.div whileTap={{ scale: 0.95 }}>
          <Button
            className="w-full h-16 text-2xl"
            onClick={handleSubmit}
            disabled={inputValue.length !== maxLength || isLoading}
          >
            {isLoading ? "Loading..." : "Enter"}
          </Button>
        </motion.div>
      </div>
    </Card>
  );
};

export default NumericInput;
