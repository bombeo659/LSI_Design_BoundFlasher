module boundFlasher (flick, clk, rst, LEDs);
  input wire flick;
  input wire clk;
  input wire rst;
  output reg [15:0] LEDs;
  
  reg [2:0] stateTemp;
  reg [2:0] stateReal;
  reg [15:0] ledTemp;
  
  reg flickFlag;
  
  always @(*) begin
    case(stateTemp)
      3'b000: begin
        ledTemp = 16'b0;
      end
      3'b001: begin
        if (LEDs[5] != 1) begin
          ledTemp = (LEDs << 1) | 1'b1;
        end
      end
      3'b010: begin
        if (LEDs[0] != 0) begin
          ledTemp = (LEDs >> 1);
        end
      end
      3'b011: begin
        if (LEDs[10] != 1) begin
          ledTemp = (LEDs << 1) | 1'b1;
        end
      end
      3'b100: begin
        if (LEDs[5] != 0) begin
          ledTemp = (LEDs >> 1);
        end
      end
      3'b101: begin
        if (LEDs[15] != 1) begin
          ledTemp = (LEDs << 1) | 1'b1;
        end
      end
      3'b110: begin
        if (LEDs[0] != 0) begin
          ledTemp = (LEDs >> 1);
        end
      end
      default: begin
        ledTemp = 16'b0;
      end
		endcase
  end


  always @(posedge clk or negedge rst) begin
    if (rst == 1'b0) begin
      LEDs <= 16'b0;
    end
    else begin
      LEDs <= ledTemp;
    end
  end
  
  
  always @(posedge clk or negedge rst) begin
    if (rst == 1'b0) begin
      stateReal <= 3'b000;
    end
    else begin
      stateReal <= stateTemp;
    end
  end


  always @(flick or stateReal or LEDs or rst) begin
    if (rst == 1'b0) begin
      flickFlag = 1'b0;
    end
    else if (flick == 1'b1 && stateReal == 3'b011 && LEDs[5] == 1 && LEDs[6] == 0) begin
      flickFlag = 1'b1;
    end
    else if (flick == 1'b1 && stateReal == 3'b011 && LEDs[10] == 1 && LEDs[11] == 0) begin
      flickFlag = 1'b1;
    end    
    else if (flick == 1'b1 && stateReal == 3'b101 && LEDs[5] == 1 && LEDs[6] == 0) begin
      flickFlag = 1'b1;
    end 
    else if (flick == 1'b1 && stateReal == 3'b101 && LEDs[10] == 1 && LEDs[11] == 0) begin
      flickFlag = 1'b1;
    end
    else begin
      flickFlag = 1'b0;
    end
  end


  always @(flick or stateReal or LEDs or rst) begin
    if (rst == 1'b0) begin
      stateTemp = 3'b000;
    end
    else begin
      case (stateReal)
        3'b000: begin // initial
          if (flick == 1) begin
            stateTemp = 3'b001;
          end
        end
        
        3'b001: begin // state 1
          if (LEDs[5] == 1) begin
            stateTemp = 3'b010;
          end
        end

        3'b010: begin // state 2
          if (LEDs[0] == 0) begin
            stateTemp = 3'b011;
          end
        end
        
        3'b011: begin // state 3
          if (flickFlag == 1'b1) begin
            stateTemp = 3'b010;
          end 
          else if (LEDs[10] == 1 && stateTemp != 3'b010) begin
            stateTemp = 3'b100;
          end
        end
        
        3'b100: begin	// state 4
          if (LEDs[5] == 0) begin
            stateTemp = 3'b101;
          end
        end
        
        3'b101: begin // state 5
          if(flickFlag == 1'b1) begin
            stateTemp = 3'b100;
          end
          if (LEDs[15] == 1 && stateTemp != 3'b100) begin
            stateTemp = 3'b110;
          end
        end
        
        3'b110: begin
          if (LEDs[0] == 0) begin
            stateTemp = 3'b000;
          end
        end
        
        default: stateTemp = 3'b000;
      endcase
    end
  end
  

endmodule