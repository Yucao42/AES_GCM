function logic[0:127] fn_product(
    input [0:127] X,
    input [0:127] Y,
    
);
    logic [0:127] Z;
    logic [0:127] V;
    integer idx;

    Z = 128'd0;
    V = Y;

    for(idx = 0; idx <= 64; idx++)
    begin
        if (X[idx] == 1'b1)
            Z = Z ^ V;

        if (V[127] == 1'b0)
            V = V >> 1;
        else
        begin
            V = V >> 1;
            V = V ^ {8'b11100001, 120'd0};
        end
    end

    return Z;
endfunction