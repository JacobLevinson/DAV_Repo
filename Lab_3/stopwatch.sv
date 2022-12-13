module stopwatch(reset, startStop, clock, outValue);
    input reg reset;
    input reg startStop;
    input reg clock;
    output reg [19:0] outValue;
    reg running = 1'b1;
    reg [19:0] counter = 1'b0;
    reg [6:0] centiSeconds;
    reg [6:0] seconds;
    reg [6:0] minutes;
   //2 dig min, 2 dig seconds, 2 dig centi
    always@(posedge startStop) begin
        running <= ~running;
    end

    always@(posedge clock) begin //every clock pulse we dont care how fast (each pule is 1 centisecond)
        // if(startStop == 0) begin
        //     running <= ~running;
        // end else begin
        //     running <= running;
        // end
        //first chech if we should reset
        if(reset == 0) begin //active LOW
            counter <= 0;
        end else if(running == 1) begin //not reseting and we are running
            counter <= counter + 1;
        end else begin //else we are paused
            counter <= counter;
        end
    end
    always_comb begin
            centiSeconds = counter % 7'd100; //get last 2 digits
            seconds = (counter/7'd100 ) % 7'd60; //convert to seconds 
            minutes = (((counter) / 7'd100) / 7'd60) % 7'd60; //mod by 60 to get min from seconds
            outValue = (centiSeconds) + (seconds * 100) + (minutes * 10000); //will give us:
            //2 dig min, 2 dig seconds, 2 dig centi
    end

endmodule