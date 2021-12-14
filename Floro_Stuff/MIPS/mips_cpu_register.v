module mips_cpu_register(
    input logic[4:0] read_register_1,
    input logic[4:0] read_register_2,
    output logic[31:0] read_data_1,
    output logic[31:0] read_data_2,
    output logic[31:0] register_v0,
    input logic[4:0] write_register,
    input logic[31:0] write_data,
    input logic clk,
    input logic reset,
    input logic Regwrite
);
    //Registers contained within MIPS
    
    logic[31:0] zero;//zero register
    logic[31:0] at; //reserved for assembler
    logic[31:0] v0;//stores results
    logic[31:0] v1;
    logic[31:0] a0;//stores arguments
    logic[31:0] a1;
    logic[31:0] a2;
    logic[31:0] a3;
    logic[31:0] t0;//temporary registers
    logic[31:0] t1;
    logic[31:0] t2;
    logic[31:0] t3;
    logic[31:0] t4;
    logic[31:0] t5;
    logic[31:0] t6;
    logic[31:0] t7;
    logic[31:0] s0;//saved temporary registers
    logic[31:0] s1;
    logic[31:0] s2;
    logic[31:0] s3;
    logic[31:0] s4;
    logic[31:0] s5;
    logic[31:0] s6;
    logic[31:0] s7;
    logic[31:0] t8;//temporary registers
    logic[31:0] t9;
    logic[31:0] k0;//reserved for OS
    logic[31:0] k1;
    logic[31:0] gp;//global pointer
    logic[31:0] sp;//stack pointer
    logic[31:0] fp;//frame pointer
    logic[31:0] ra;//return address



    always_comb begin//output from register
        if(reset==1) begin//reset behaviour
            read_data_1=0;
            read_data_2=0;
        end
        else begin//runtime behaviour
            case(read_register_1)//reading from register 1 based on MIPS GPR index
            0 : read_data_1=zero;
            1 : read_data_1=at;
            2 : read_data_1=v0;
            3 : read_data_1=v1;
            4 : read_data_1=a0;
            5 : read_data_1=a1;
            6 : read_data_1=a2;
            7 : read_data_1=a3;
            8 : read_data_1=t0;
            9 : read_data_1=t1;
            10 : read_data_1=t2;
            11 : read_data_1=t3;
            12 : read_data_1=t4;
            13 : read_data_1=t5;
            14 : read_data_1=t6;
            15 : read_data_1=t7;
            16 : read_data_1=s0;
            17 : read_data_1=s1;
            18 : read_data_1=s2;
            19 : read_data_1=s3;
            20 : read_data_1=s4;
            21 : read_data_1=s5;
            22 : read_data_1=s6;
            23 : read_data_1=s7;
            24 : read_data_1=t8;
            25 : read_data_1=t9;
            26 : read_data_1=k0;
            27 : read_data_1=k1;
            28 : read_data_1=gp;
            29 : read_data_1=sp;
            30 : read_data_1=fp;
            31 : read_data_1=ra;
            endcase
            case(read_register_2)//reading from register 2 based on MIPS GPR index
            0 : read_data_2=zero;
            1 : read_data_2=at;
            2 : read_data_2=v0;
            3 : read_data_2=v1;
            4 : read_data_2=a0;
            5 : read_data_2=a1;
            6 : read_data_2=a2;
            7 : read_data_2=a3;
            8 : read_data_2=t0;
            9 : read_data_2=t1;
            10 : read_data_2=t2;
            11 : read_data_2=t3;
            12 : read_data_2=t4;
            13 : read_data_2=t5;
            14 : read_data_2=t6;
            15 : read_data_2=t7;
            16 : read_data_2=s0;
            17 : read_data_2=s1;
            18 : read_data_2=s2;
            19 : read_data_2=s3;
            20 : read_data_2=s4;
            21 : read_data_2=s5;
            22 : read_data_2=s6;
            23 : read_data_2=s7;
            24 : read_data_2=t8;
            25 : read_data_2=t9;
            26 : read_data_2=k0;
            27 : read_data_2=k1;
            28 : read_data_2=gp;
            29 : read_data_2=sp;
            30 : read_data_2=fp;
            31 : read_data_2=ra;
            endcase
        end
    end

    always_ff @(posedge clk) begin//writing to register
        if(reset==1) begin//reseting all GPR to 0
            zero <= 0;
            at <= 0;
            v0 <= 0;
            v1 <= 0;
            a0 <= 0;
            a1 <= 0;
            a2 <= 0;
            a3 <= 0;
            t0 <= 0;
            t1 <= 0;
            t2 <= 0;
            t3 <= 0;
            t4 <= 0;
            t5 <= 0;
            t6 <= 0;
            t7 <= 0;
            s0 <= 0;
            s1 <= 0;
            s2 <= 0;
            s3 <= 0;
            s4 <= 0;
            s5 <= 0;
            s6 <= 0;
            s7 <= 0;
            t8 <= 0;
            t9 <= 0;
            k0 <= 0;
            k1 <= 0;
            gp <= 0;
            sp <= 0;
            fp <= 0;
            ra <= 0;
        end
        else if(Regwrite==1) begin//begin writing GPR based on their index if writeenable is high
            case(write_register)
            0 : zero <= write_data;
            1 : at <= write_data;
            2 : v0 <= write_data;
            3 : v1 <= write_data;
            4 : a0 <= write_data;
            5 : a1 <= write_data;
            6 : a2 <= write_data;
            7 : a3 <= write_data;
            8 : t0 <= write_data;
            9 : t1 <= write_data;
            10 : t2 <= write_data;
            11 : t3 <= write_data;
            12 : t4 <= write_data;
            13 : t5 <= write_data;
            14 : t6 <= write_data;
            15 : t7 <= write_data;
            16 : s0 <= write_data;
            17 : s1 <= write_data;
            18 : s2 <= write_data;
            19 : s3 <= write_data;
            20 : s4 <= write_data;
            21 : s5 <= write_data;
            22 : s6 <= write_data;
            23 : s7 <= write_data;
            24 : t8 <= write_data;
            25 : t9 <= write_data;
            26 : k0 <= write_data;
            27 : k1 <= write_data;
            28 : gp <= write_data;
            29 : sp <= write_data;
            30 : fp <= write_data;
            31 : ra <= write_data;
            endcase
        end
    end

    assign register_v0=v0;

endmodule