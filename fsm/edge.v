// edgeDetector.v
// Moore and Mealy Implementation

module edgeDetector
(
    input wire clk, reset, 
    input wire level, 
    output reg Mealy_tick, Moore_tick
);

localparam  // 2 states are required for Mealy
    zeroMealy = 1'b0,
    oneMealy =  1'b1;
    
localparam [1:0] // 3 states are required for Moore
    zeroMoore = 2'b00,
    edgeMoore = 2'b01, 
    oneMoore = 2'b10;

reg stateMealy_reg, stateMealy_next; 
reg[1:0] stateMoore_reg, stateMoore_next;

always @(posedge clk, posedge reset)
begin
    if(reset) // go to state zero if rese
        begin
        stateMealy_reg <= zeroMealy;
        stateMoore_reg <= zeroMoore;
        end
    else // otherwise update the states
        begin
        stateMealy_reg <= stateMealy_next;
        stateMoore_reg <= stateMoore_next;
        end
end

// Mealy Design 
always @(stateMealy_reg, level)
begin
    // store current state as next
    stateMealy_next = stateMealy_reg; // required: when no case statement is satisfied
    
    Mealy_tick = 1'b0; // set tick to zero (so that 'tick = 1' is available for 1 cycle only)
    case(stateMealy_reg)
        zeroMealy: // set 'tick = 1' if state = zero and level = '1'
            if(level)  
                begin // if level is 1, then go to state one,
                    stateMealy_next = oneMealy; // otherwise remain in same state.
                    Mealy_tick = 1'b1;
                end
        oneMealy: 
            if(~level) // if level is 0, then go to zero state,
                stateMealy_next = zeroMealy; // otherwise remain in one state.
    endcase
end

// Moore Design 
always @(stateMoore_reg, level)
begin
    // store current state as next
    stateMoore_next = stateMoore_reg; // required: when no case statement is satisfied
    
    Moore_tick = 1'b0; // set tick to zero (so that 'tick = 1' is available for 1 cycle only)
    case(stateMoore_reg)
        zeroMoore: // if state is zero,
            if(level) // and level is 1
                stateMoore_next = edgeMoore; // then go to state edge.
        edgeMoore:
            begin
                Moore_tick = 1'b1; // set the tick to 1.
                if(level) // if level is 1, 
                    stateMoore_next = oneMoore; // go to state one,
                else    
                    stateMoore_next = zeroMoore; // else go to state zero.
            end
        oneMoore: 
            if(~level) // if level is 0,
                stateMoore_next = zeroMoore; // then go to state zero.      
    endcase
end
endmodule
