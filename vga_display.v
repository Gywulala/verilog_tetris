

module vga_display(
    input                  en,
    input  [1439:0]       data   ,
    input  [507:0]       data_1   ,
    input   [7:0]	      data_T   ,
    input wire                                   clk,
    input wire [ BITS_PER_BLOCK-1:0]             cur_piece,
    input wire [ BITS_BLK_POS-1:0]               cur_blk_1,
    input wire [ BITS_BLK_POS-1:0]               cur_blk_2,
    input wire [ BITS_BLK_POS-1:0]               cur_blk_3,
    input wire [ BITS_BLK_POS-1:0]               cur_blk_4,
    input wire [( BLOCKS_WIDE* BLOCKS_HIGH)-1:0] fallen_pieces,
    output reg [7:0]                             rgb,
    output reg                                  hsync,
    output reg                                  vsync,
	 output [5:0]    rom_adder_16 ,
    output [15:0]	          adder,
    output                 rom_en,
	 output [5:0]    rom_adder_17 ,
    output [15:0]	          adder_1,
    output                 rom_en_1
    );
	 
    reg    					spriteon  ;
	 reg    				  spriteon_T ;
	 reg                    rom_en;
	 reg                    rom_en_1   				;//t
    reg                    spriteon_1 				;//����ʾ������Ч//t
	 wire       [10:0]      rom_adder_1				;
    wire       [10:0]      rom_pix_1  				;
	 wire       [507:0]     data_1                ;//�ַ�rom
	 wire       [5:0]       adder_1               ;
reg vidon;
					
	 wire   [10:0]			rom_adder;
	 wire   [10:0]			rom_pix	;
	 wire   [10:0]        y_pix   ;
    wire   [10:0]        x_pix   ;
	 wire   [16:0]      rom_adder1;
    wire   [16:0]      rom_adder2;
	 wire [2:0] red;
	 wire [2:0]  green;
	 wire  [1:0]blue;
	 wire  [15:0]adder;
parameter 					PIXEL_WIDTH = 1024;
parameter 					PIXEL_HEIGHT = 768;
parameter 					HSYNC_FRONT_PORCH = 24;
parameter 					HSYNC_PULSE_WIDTH = 136;
parameter 					HSYNC_BACK_PORCH = 160;
parameter 					VSYNC_FRONT_PORCH = 3;
parameter 					VSYNC_PULSE_WIDTH = 6;
parameter 					VSYNC_BACK_PORCH = 29;
parameter  H_BP  =11'd296 ;        //����ʾ���أ�96+48��
parameter  V_BP  =11'd35  ;        //����ʾ���� (2+33 ��
parameter  DATA_W=11'd800 ;     //��ʾ���ݵĿ�� ��32�У�
parameter  DATA_H=40'd40  ;        //��ʾ���ݵĸ߶� ��16�У�


parameter  W=11'd70      ;        // X����ƫ�Ƶ�λ��
parameter  H=10'd98       ;       // Y����ƫ�Ƶ�λ��



parameter  W_1		= 10'd247							;// X����ƫ�Ƶ�λ��
parameter  H_1		= 10'd364							;// Y����ƫ�Ƶ�λ��
parameter  DATA_W_1= 10'd500							;//��ʾ���ݵĿ�� 
parameter  DATA_H_1= 10'd40								;//��ʾ���ݵĸ߶� 

assign  rom_adder      =  counter_y-V_BP-H;
assign  rom_pix        =  counter_x-H_BP-W;
assign  rom_adder_16   =  rom_adder[5:0];

assign  rom_adder_1		=  counter_y-V_BP-H_1			;
assign  rom_pix_1			=  counter_x-H_BP-W_1			;
assign  rom_adder_17	  	=  rom_adder_1[5:0]	; //rom��ʵ�ʵ�ַ

// ÿ�����ж������ؿ�/��
parameter BLOCK_SIZE =30;

// ��Ϸ������һ���ж��ٿ�
parameter BLOCKS_WIDE =10;

// ��Ϸ���������λ���ٿ�
parameter BLOCKS_HIGH =22;
// ��Ϸ��Ŀ�ȣ����أ�
parameter BOARD_WIDTH =( BLOCKS_WIDE *  BLOCK_SIZE);
// �����ʼλ��(x)
parameter BOARD_X =((( PIXEL_WIDTH -  BOARD_WIDTH) / 2)+310 );

// ��Ϸ��ĸ߶�(���أ�
parameter BOARD_HEIGHT =( BLOCKS_HIGH *  BLOCK_SIZE);
// ����ĳ�ʼλ��(y)
parameter BOARD_Y =((( PIXEL_HEIGHT -  BOARD_HEIGHT) / 2)-1);

// ���ڴ洢��λ�õ�λ����
parameter BITS_BLK_POS =8;
// ���ڴ洢Xλ�õ�λ����
parameter BITS_X_POS =4;
// ���ڴ洢Yλ�õ�λ��
parameter BITS_Y_POS= 5;
// ���ڴ洢��ת��λ��
parameter BITS_ROT= 2;
// ���ڴ洢��Ŀ��/���ȵ�λ�������ֵΪʮ����4��
parameter BITS_BLK_SIZE =3;
// ������λ���� �÷�������9999
parameter BITS_SCORE =14;
// ���ڴ洢��ֹ�����λ��
parameter BITS_PER_BLOCK =3;
parameter H_BACK = HSYNC_PULSE_WIDTH + HSYNC_BACK_PORCH;
parameter V_BACK = VSYNC_PULSE_WIDTH + VSYNC_BACK_PORCH;
parameter H_TOTAL = H_BACK + PIXEL_WIDTH + HSYNC_FRONT_PORCH;
parameter V_TOTAL = V_BACK + PIXEL_HEIGHT + VSYNC_FRONT_PORCH;
parameter EMPTY_BLOCK =3'b000;
parameter I_BLOCK =3'b001;
parameter O_BLOCK =3'b010;
parameter T_BLOCK =3'b011;
parameter S_BLOCK =3'b100;
parameter Z_BLOCK =3'b101;
parameter J_BLOCK =3'b110;
parameter L_BLOCK =3'b111;

// �����ɫ��ֵ
parameter WHITE =8'b11111111;
parameter BLACK =8'b00000000;
parameter GRAY =8'b10100100;
parameter CYAN =8'b11110000;
parameter YELLOW =8'b00111111;
parameter PURPLE= 8'b11000111;
parameter GREEN =8'b00111000;
parameter RED =8'b00000111;
parameter BLUE =8'b11000000;
parameter ORANGE =8'b00011111;
  parameter H_SYNC   = 10'd136;      //��ͬ�� 
  parameter H_DISP   = 11'd1024;     //����Ч���� 
  parameter H_FRONT  = 10'd24;      //����ʾǰ�� 
  parameter V_SYNC   = 10'd6;       //��ͬ�� 
  parameter V_DISP   = 10'd768;     //����Ч���� 
  parameter V_FRONT  = 10'd3;      //����ʾǰ�� 

assign  rom_adder      =  counter_y-V_BP-H;
assign  rom_pix        =  counter_x-H_BP-W;
assign  rom_adder_16   =  rom_adder[5:0];

assign  rom_adder_1		=  counter_y-V_BP-H_1			;
assign  rom_pix_1			=  counter_x-H_BP-W_1			;
assign  rom_adder_17	  	=  rom_adder_1[5:0]	;

    reg [10:0] counter_x = 0;
    reg [10:0] counter_y = 0;
 
   

    // Combinational logic to select the current pixel
    wire [10:0] cur_blk_index = ((counter_x- BOARD_X)/ BLOCK_SIZE) + (((counter_y- BOARD_Y)/ BLOCK_SIZE)* BLOCKS_WIDE);
    reg [2:0] cur_vid_mem;
	 
	 always@(*)begin

      if  (((counter_x >= 298) && (counter_x < 1332)) 
         &&((counter_y>= 35) && (counter_y < 803))) begin 
            
             vidon=1'b1;
        end

        else begin
        
            vidon=1'b0;
        end

    end
	 
	 always  @(*)begin

        if  (((counter_x >= H_BP+W) && (counter_x < H_BP+W+DATA_W)) 
         &&((counter_y >= V_BP+H) && (counter_y < V_BP+H+DATA_H))) begin 
            
             spriteon=1'b1;
        end
        else begin
        
            spriteon=1'b0;
        end
end

	always@(*)begin
		if  (((counter_x >= H_BP+W_1) && (counter_x < H_BP+W_1+DATA_W_1)) 
			&&((counter_y >= V_BP+H_1) && (counter_y < V_BP+H_1+DATA_H_1))) begin 
			
				spriteon_1 = 1'b1;
		end
		else begin
				spriteon_1 = 1'b0;
		end
	end

	
    always @ (clk) begin
	 if(!en)begin
if((vidon==1'b1)&&(spriteon==1'b1))begin
        
        if (data[790-rom_pix]==1'b1) begin      //�ַ���ʾ��ɫ

           rgb=PURPLE;

        end
        else begin                      //���ַ���ʾ��ɫ

          rgb=BLACK;

   
        end  
        end
		  else if((vidon==1'b1)&&(spriteon_1==1'b1))begin
				if(data_1[510-rom_pix_1]==1'b1) begin   		//�ַ���ʾ��ɫ
					rgb=PURPLE;
				end
				else begin										 	 	//���ַ���ʾ��ɫ
				  rgb=BLACK;
				end
        
        end
    else begin                           //��ʾ��ɫ

       rgb=BLACK;
   
    end  
end
else begin
        if (counter_x >= BOARD_X && counter_y >= BOARD_Y &&
			counter_x <= BOARD_X + BOARD_WIDTH && counter_y <= BOARD_Y + BOARD_HEIGHT) begin
		if (counter_x == BOARD_X || counter_x == BOARD_X + BOARD_WIDTH ||
				counter_y == BOARD_Y || counter_y == BOARD_Y + BOARD_HEIGHT) begin
                // ��Ϸ����߿�
                rgb =  WHITE;
            end else begin
                if (cur_blk_index == cur_blk_1 ||
                    cur_blk_index == cur_blk_2 ||
                    cur_blk_index == cur_blk_3 ||
                    cur_blk_index == cur_blk_4) begin
                    case (cur_piece)
                         EMPTY_BLOCK: rgb =  CYAN;
                         I_BLOCK: rgb = GRAY;
                         O_BLOCK: rgb = YELLOW;
                         T_BLOCK: rgb =  PURPLE;
                         S_BLOCK: rgb =  GREEN;
                         Z_BLOCK: rgb =  RED;
                         J_BLOCK: rgb = BLUE;
                         L_BLOCK: rgb =  ORANGE;
                    endcase
                end else begin
                    rgb = fallen_pieces[cur_blk_index] ?  WHITE :  CYAN;
                end
            end
        end 
		  else begin
            // ��Ϸ������
            rgb =  BLACK;
        end
		  end
    end

always@(posedge clk)begin
   if (counter_x==H_TOTAL-1) begin
      counter_x<=11'b0;
      end
   else begin
      counter_x<=counter_x+1'b1;
      end
   end

//��ɨ�������
always@(posedge clk)begin		
   if(counter_x==H_TOTAL-1) begin			//һ��һ��ɨ
      if(counter_y==V_TOTAL-1) begin
			counter_y<=10'b0;
         end           
      else begin
         counter_y<=counter_y+1'b1;
         end
      end
	else begin
      counter_y<=counter_y;
      end
   end
	assign rom_adder1={y_pix,7'b0000000}+{1'b0,y_pix,6'b000000}
                  +{2'b00,y_pix,5'b00000}+{3'b000,y_pix,4'b0000};

assign rom_adder2=rom_adder1+{8'b0000_0000,x_pix};

assign  adder   =  rom_adder2[15:0]; //rom��ʵ�ʵ�ַ   
assign  y_pix =  counter_y-V_BP-H;  //0-159
assign  x_pix =  counter_x-H_BP-W;  //0-239
wire hsync1;
wire vsync1;
assign hsync1 = (counter_x <= 136 - 1'b1) ? 1'b0 : 1'b1; 

assign vsync1 = (counter_y <= 6 - 1'b1) ? 1'b0 : 1'b1; 

always@(posedge clk)begin	
hsync<=hsync1;
vsync<=vsync1;
end	
endmodule
