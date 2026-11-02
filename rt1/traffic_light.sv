module traffic_light #(
  parameter int GREEN_T  = 5,
  parameter int YELLOW_T = 2,
  parameter int RED_T    = 4
)(
  input  logic clk,
  input  logic rst_n,
  output logic green,
  output logic yellow,
  output logic red
);
  typedef enum logic [1:0] {GREEN_S, YELLOW_S, RED_S} state_t;
  state_t state, next_state;
  int unsigned cnt;

  // cycle count + registry state
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= RED_S;
      cnt   <= 0;
    end else begin
      state <= next_state;
      if (next_state != state) cnt <= 0;
      else                     cnt <= cnt + 1;
    end
  end

  // logic scheme
  always_comb begin
    next_state = state;
    case (state)
      GREEN_S:  if (cnt == GREEN_T-1)  next_state = YELLOW_S;
      YELLOW_S: if (cnt == YELLOW_T-1) next_state = RED_S;
      RED_S:    if (cnt == RED_T-1)    next_state = GREEN_S;
      default:  next_state = RED_S;
    endcase
  end

  // outputs
  always_comb begin
    green  = (state == GREEN_S);
    yellow = (state == YELLOW_S);
    red    = (state == RED_S);
  end
endmodule
