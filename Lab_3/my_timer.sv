module my_timer(switches, reset, startStop, clock, outValue, buzzer);
    input [9:0] switches;
    input reset;
    input startStop;
    input clock; 
    output [19:0] outValue;
    output buzzer;
    reg pause = 1;
    reg int_pauseA = 1;
    reg int_pauseB = 0;
	reg intermediate = 0;
    reg [1:0] state = 2'b00;
    reg [19:0] counter = 1'b0;
    reg [6:0] centiSeconds;
    reg [6:0] seconds;
    reg [6:0] minutes;
    always@(posedge startStop) begin
        int_pauseA <= ~int_pauseA;
    end
    always@(posedge intermediate) begin
        int_pauseB <= ~int_pauseB;
    end
    always@(posedge clock) begin
        pause = int_pauseA^int_pauseB;
        case(state)
            2'b00: begin //SET
                intermediate <= 0;
				counter <= (switches*7'd100);
                buzzer <= 0;
				if(pause == 1'b0) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin //RUN
                counter <= counter - 1;
                buzzer <= 0;
                if(reset == 0) begin //active low
                    state <= 2'b00;
                    intermediate <= 1;
                end else if(pause == 1) begin //goto paused state
					state <= 2'b10;
                end else if(counter == 0) begin //we are at time 0
                    state <= 2'b11;
                end else begin
                    state <= 2'b01;
                end  
            end
            2'b10: begin //PAUSE
                counter <= counter;
                buzzer <= 0;
                if(reset == 0) begin //active low
                    state <= 2'b00;
                    intermediate <= 1;
                end else if(pause == 0) begin // we unpause goto RUN
                    state <= 2'b01;
                end else begin //stay
                    state <= 2'b10; 
                end
            end
            2'b11: begin
                buzzer <= ~buzzer; //BUZZZZZ
                counter <= 0;
                if(reset ==0) begin
                    intermediate <= 1;
                    state <= 2'b00;
                end
            end


        endcase
            centiSeconds = counter % 7'd100; //get last 2 digits
            seconds = (counter/7'd100 ) % 7'd60; //convert to seconds 
            minutes = (((counter) / 7'd100) / 7'd60) % 7'd60; //mod by 60 to get min from seconds
            outValue = (centiSeconds) + (seconds * 100) + (minutes * 10000); //will give us:
            //2 dig min, 2 dig seconds, 2 dig centi
    end

	
endmodule