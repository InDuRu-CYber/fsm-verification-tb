module tb;
  logic clk = 0;
  logic rst_n = 0;
  logic green, yellow, red;
  int errors = 0;

  localparam logic [2:0] RED_ON    = 3'b100;
  localparam logic [2:0] GREEN_ON  = 3'b010;
  localparam logic [2:0] YELLOW_ON = 3'b001;

  traffic_light #(.GREEN_T(5), .YELLOW_T(2), .RED_T(4)) dut (.*);

  always #5 clk = ~clk;

  task automatic check_phase(input logic [2:0] expected, input int cycles);
    repeat (cycles) begin
      if ({red, green, yellow} !== expected) begin
        $error("t=%0t: waited %b, returned %b", $time, expected, {red, green, yellow});
        errors++;
      end
      @(negedge clk);
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);

    repeat (2) @(negedge clk);   
    rst_n = 1;                   

    check_phase(RED_ON, 4);
    repeat (2) begin
      check_phase(GREEN_ON, 5);
      check_phase(YELLOW_ON, 2);
      check_phase(RED_ON, 4);
    end

    if (errors == 0) $display("TEST PASSED");
    else             $display("TEST FAILED: %0d errors", errors);
    $finish;
  end
endmodule
