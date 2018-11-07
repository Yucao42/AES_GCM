function logic [0:127] fn_product(
    input [0:127] X,
    input [0:127] Y
);
    logic [0:127] Z;
    logic [0:127] V;
    integer idx;

    Z = 128'd0;
    V = Y;

    for(idx = 0; idx <= 127; idx++)
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

function logic [0:255] fn_product1(
    input [0:127] X,
    input [0:127] Y
);
    logic [0:127] Z;
    logic [0:127] V;
    integer idx;

    Z = 128'd0;
    V = Y;

    for(idx = 0; idx <= 63; idx++)
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

    return {Z, V};
endfunction

function logic [0:127] fn_product2(
    input [0:255] X
);
    logic [0:127] Z = X[0:127];
    logic [0:127] V = X[128+:128];
    integer idx;

    for(idx = 0; idx <= 63; idx++)
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

// Do 3 multiplications in one function
function logic[0:127] fn_3product(
    input [0:127] X,
    input [0:127] Y,
    input [0:127] A,
    input [0:127] B
);
    logic [0:127] Z;
    logic [0:127] ZZ;
    logic [0:127] V;
    integer idx;
    
    Z = 128'd0;
    V = Y;
    
    // X * Y, 
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
    
    // X * Y * A, Z = X * Y
    ZZ = 128'd0;
    V = A;
    
    for(idx = 0; idx <= 64; idx++)
    begin
        if (Z[idx] == 1'b1)
            ZZ = ZZ ^ V;
    
        if (V[127] == 1'b0)
            V = V >> 1;
        else
        begin
            V = V >> 1;
            V = V ^ {8'b11100001, 120'd0};
        end
    end
    
    //X * Y * A * B, ZZ = X * Y * A
    Z = 128'd0;
    V = B;
    
    for(idx = 0; idx <= 64; idx++)
    begin
        if (ZZ[idx] == 1'b1)
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
