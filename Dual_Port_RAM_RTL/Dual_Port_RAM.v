module Dual_Port_RAM #(parameter IN_DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
input wire [IN_DATA_WIDTH-1:0] Data_1,
input wire [IN_DATA_WIDTH-1:0] Data_2,
input wire [ADDR_WIDTH-1:0] Address_1,
input wire [ADDR_WIDTH-1:0] Address_2,
input wire WE_1,
input wire WE_2,
input wire CLK,
output wire [IN_DATA_WIDTH-1:0] Output_1,
output wire [IN_DATA_WIDTH-1:0] Output_2
);

reg [IN_DATA_WIDTH-1:0] RAM [0: (2**ADDR_WIDTH-1)];
reg [ADDR_WIDTH-1:0] Address_Reg_1;
reg [ADDR_WIDTH-1:0] Address_Reg_2;

always @(posedge CLK)
begin
   if(WE_1)
    begin
        RAM[Address_1] <= Data_1;
    end
    else
    begin
        Address_Reg_1 <= Address_1;
    end
end

assign Output_1 = RAM[Address_Reg_1];

always @(posedge CLK)
begin
   if(WE_2)
    begin
        RAM[Address_2] <= Data_2;
    end
    else
    begin
        Address_Reg_2 <= Address_2;
    end
end

assign Output_2 = RAM[Address_Reg_2];

endmodule
