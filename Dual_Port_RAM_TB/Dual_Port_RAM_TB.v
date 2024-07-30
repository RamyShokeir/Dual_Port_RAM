`include "Dual_Port_RAM.v"
`timescale 1ns / 1ps
module Dual_Port_RAM_TB #(parameter IN_DATA_WIDTH_TB = 8, parameter ADDR_WIDTH_TB = 6);


    // Inputs
    reg [IN_DATA_WIDTH_TB-1:0] Data_1_TB;
    reg [IN_DATA_WIDTH_TB-1:0] Data_2_TB;
    reg [ADDR_WIDTH_TB-1:0] Address_1_TB;
    reg [ADDR_WIDTH_TB-1:0] Address_2_TB;
    reg WE_1_TB;
    reg WE_2_TB;
    reg CLK_TB;

    // Outputs
    wire [IN_DATA_WIDTH_TB-1:0] Output_1_TB;
    wire [IN_DATA_WIDTH_TB-1:0] Output_2_TB;

    parameter CLK_PERIOD = 10;

    initial begin
        initialize;
        
        // Test 1: Write to address 0 with port 1 and read with port 1
        write_data_1(6'b000000, 8'hB5);
        read_data_1(6'b000000, 8'hB5);

        // Test 2: Write to address 1 with port 2 and read with port 2
        write_data_2(6'b000001, 8'hD4);
        read_data_2(6'b000001, 8'hD4);

        // Test 3: Write to address 2 with port 1 and read with port 2
        write_data_1(6'b000010, 8'hA3);
        read_data_2(6'b000010, 8'hA3);

        // Additional tests can be added here

        $stop;
    end

    task initialize;
    begin
        Address_1_TB = 0;
        Address_2_TB = 0;
        Data_1_TB = 0;
        Data_2_TB = 0;
        WE_1_TB = 0;
        WE_2_TB = 0;
        CLK_TB = 0;
    end
    endtask

    task write_data_1;
        input [ADDR_WIDTH_TB-1:0] addr;
        input [IN_DATA_WIDTH_TB-1:0] data;
    begin
        @(posedge CLK_TB);
        Address_1_TB = addr;
        Data_1_TB = data;
        WE_1_TB = 1;
        @(posedge CLK_TB);
        WE_1_TB = 0;
    end
    endtask

    task write_data_2;
        input [ADDR_WIDTH_TB-1:0] addr;
        input [IN_DATA_WIDTH_TB-1:0] data;
    begin
        @(posedge CLK_TB);
        Address_2_TB = addr;
        Data_2_TB = data;
        WE_2_TB = 1;
        @(posedge CLK_TB);
        WE_2_TB = 0;
    end
    endtask

    task read_data_1;
        input [ADDR_WIDTH_TB-1:0] addr;
        input [IN_DATA_WIDTH_TB-1:0] expected_data;
    begin
        @(posedge CLK_TB);
        Address_1_TB = addr;
        WE_1_TB = 0;
        @(posedge CLK_TB);
        check_output_1(expected_data);
    end
    endtask

    task read_data_2;
        input [ADDR_WIDTH_TB-1:0] addr;
        input [IN_DATA_WIDTH_TB-1:0] expected_data;
    begin
        @(posedge CLK_TB);
        Address_2_TB = addr;
        WE_2_TB = 0;
        @(posedge CLK_TB);
        check_output_2(expected_data);
    end
    endtask

    task check_output_1;
        input [IN_DATA_WIDTH_TB-1:0] expected_data;
    begin
        if (Output_1_TB == expected_data) begin
            $display("Test Passed (Port 1): Expected %h, Received %h", expected_data, Output_1_TB);
        end else begin
            $display("Test Failed (Port 1): Expected %h, Received %h", expected_data, Output_1_TB);
        end
    end
    endtask

    task check_output_2;
        input [IN_DATA_WIDTH_TB-1:0] expected_data;
    begin
        if (Output_2_TB == expected_data) begin
            $display("Test Passed (Port 2): Expected %h, Received %h", expected_data, Output_2_TB);
        end else begin
            $display("Test Failed (Port 2): Expected %h, Received %h", expected_data, Output_2_TB);
        end
    end
    endtask

    // Clock generator
    always #(CLK_PERIOD/2) CLK_TB = ~CLK_TB;

    // Module instantiation
    Dual_Port_RAM #(.IN_DATA_WIDTH(IN_DATA_WIDTH_TB), .ADDR_WIDTH(ADDR_WIDTH_TB)) DUT (
        .Data_1(Data_1_TB),
        .Data_2(Data_2_TB),
        .Address_1(Address_1_TB),
        .Address_2(Address_2_TB),
        .WE_1(WE_1_TB),
        .WE_2(WE_2_TB),
        .CLK(CLK_TB),
        .Output_1(Output_1_TB),
        .Output_2(Output_2_TB)
    );

endmodule
