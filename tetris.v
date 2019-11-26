`include "definitions.vh"
module tetris(
input wire en,
    input wire        clk_too_fast,
    input wire        btn_drop,
    input wire        btn_rotate,
    input wire        btn_left,
    input wire        btn_right,
    input wire        btn_down,
    input wire        sw_pause,
    input wire        sw_rst,
    output wire [7:0] rgb,
    output wire       hsync,
    output wire       vsync,
    output wire [7:0] seg,
    output wire [3:0] an,
	 input wire   clk_rst
    );




    //���65M��ʱ��
	 	wire  [5:0] rom_addr;
	wire  [1439:0] data;
	wire [15:0] rom_addr_T;
	wire [15:0] rom_addr_T1;
	wire  [5:0] rom_addr_1;
	wire  [507:0] data_1;


	 wire clk;
	 wire clk_65;
	 wire LOCKED;
	 
	 
	 rom_data    u4   ( .adder (rom_addr)     ,
                   .data (data)
                 );
					  
rom_data1  u5   ( .adder_1 (rom_addr_1) ,
                   .data_1 (data_1)
                 );
 clk_65M instance_name
   (// Clock in ports
    .CLK(clk_too_fast),      // IN
    .CLK_45M(clk),
	 .CLK_65M(clk_65),     // OUT
    // Status and control signals
    .RESET(clk_rst),// IN
    .LOCKED(LOCKED)); 
	    // ÿѭ������һ�Σ��ﵽ���ֵ�������û�дﵽ���ֵ���Ͳ��ܽ����½�ģʽ��
    reg [31:0] drop_timer;
    initial begin
        drop_timer = 0;
    end
	 


    // T���ź��������100�׺�Ƶ�����ڲ�ͬ���͵Ŀ�֮����ת��
	 //�������û��������ѡ��ʹ����Ч�������
    wire [`BITS_PER_BLOCK-1:0] random_piece;
    randomizer randomizer_ (
        .clk(clk),
        .random(random_piece)
    );

    // �����ťͨ��ȥ�����������źš�ÿ��һ�ΰ�ť��һ��������ֻ�ܰ�һ����
    wire btn_drop_en;
    wire btn_rotate_en;
    wire btn_left_en;
    wire btn_right_en;
    wire btn_down_en;
    // �������������źŵĸ���
    debouncer debouncer_btn_drop_ (
        .raw(btn_drop),
        .clk(clk),
        .enabled(btn_drop_en)
    );
    debouncer debouncer_btn_rotate_ (
        .raw(btn_rotate),
        .clk(clk),
        .enabled(btn_rotate_en)
    );
    debouncer debouncer_btn_left_ (
        .raw(btn_left),
        .clk(clk),
        .enabled(btn_left_en)
    );
    debouncer debouncer_btn_right_ (
        .raw(btn_right),
        .clk(clk),
        .enabled(btn_right_en)
    );
    debouncer debouncer_btn_down_ (
        .raw(btn_down),
        .clk(clk),
        .enabled(btn_down_en)
    );

    // Sets up wires for the pause and reset switch enable
    // and disable signals, and debounces the asynchronous input.
    wire sw_pause_en;
    wire sw_pause_dis;
    wire sw_rst_en;
    wire sw_rst_dis;
    debouncer debouncer_sw_pause_ (
        .raw(sw_pause),
        .clk(clk),
        .enabled(sw_pause_en),
        .disabled(sw_pause_dis)
    );
    debouncer debouncer_sw_rst_ (
        .raw(sw_rst),
        .clk(clk),
        .enabled(sw_rst_en),
        .disabled(sw_rst_dis)
    );

    // һ�ִ洢���飬����Ϊÿ����λ�ô洢1λ���������ķ���Ϊ1��������һ����δ����Ϸ���Ƴ��������������ƺͲ���������ķ����ھ�ֹ�Ľ��档
    reg [(`BLOCKS_WIDE*`BLOCKS_HIGH)-1:0] fallen_pieces;

    // ��ǰ׹��ķ�����ʲô���͵ķ���
    reg [`BITS_PER_BLOCK-1:0] cur_piece;
    //�����xλ�á�
    reg [`BITS_X_POS-1:0] cur_pos_x;
    //�����yλ�á�.
    reg [`BITS_Y_POS-1:0] cur_pos_y;
    // �����ĵ�ǰ��ת��0=0�ȡ�1=90�ȵȣ�
    reg [`BITS_ROT-1:0] cur_rot;
    // ��ǰ�½���С������ĸ�λ�á����ڲ��Խ���㣬����ӵ����µķ����
    wire [`BITS_BLK_POS-1:0] cur_blk_1;
    wire [`BITS_BLK_POS-1:0] cur_blk_2;
    wire [`BITS_BLK_POS-1:0] cur_blk_3;
    wire [`BITS_BLK_POS-1:0] cur_blk_4;
    // ���ݷ�������ͺ���ת��ȷ���䵱ǰ��״�Ŀ�Ⱥ͸߶ȡ�
    wire [`BITS_BLK_SIZE-1:0] cur_width;
    wire [`BITS_BLK_SIZE-1:0] cur_height;
    //ʹ��Calc Cur_BLKģ�������ķ��鵱ǰλ�á����ͺ���ת�л�ȡ������ֵ��
    calc_cur_blk calc_cur_blk_ (
        .piece(cur_piece),
        .pos_x(cur_pos_x),
        .pos_y(cur_pos_y),
        .rot(cur_rot),
        .blk_1(cur_blk_1),
        .blk_2(cur_blk_2),
        .blk_3(cur_blk_3),
        .blk_4(cur_blk_4),
        .width(cur_width),
        .height(cur_height)
    );

    // VGA��ʾ�����Ǹ���һ�����飨cur-piece�������ͣ��Ա���֪����ȷ����ɫ��
	 //�Լ��������ǵİ��ϵ��ĸ�λ�á�����Ҳ��ͨ���������ķ��飬
	// �������Ϳ����Ե�ɫ��ʾ�������ķ��顣
    vga_display display_ (
	      .en(en),
        .clk(clk_65),
        .cur_piece(cur_piece),
        .cur_blk_1(cur_blk_1),
        .cur_blk_2(cur_blk_2),
        .cur_blk_3(cur_blk_3),
        .cur_blk_4(cur_blk_4),
        .fallen_pieces(fallen_pieces),
        .rgb(rgb),
        .hsync(hsync),
        .vsync(vsync),
		  .rom_adder_16(rom_addr),
		  .data(data),
			.rom_en(rom_en),
			.adder(rom_addr_T),
			.data_T(data_T),
			.data_1(data_1),
		   .rom_adder_17(rom_addr_1),
			.adder_1(rom_addr_T1),
			.rom_en_1(rom_en_1)
    );

    // ��������״̬�����¼������ǻ���Ҫż���洢��ģʽ��������ͣʱ��
    reg [`MODE_BITS-1:0] mode;
    reg [`MODE_BITS-1:0] old_mode;
    // ��Ϸʱ��
    wire game_clk;
    //��Ϸʱ�Ӹ�λ
    reg game_clk_rst;

    // ���ģ�������Ϸʱ�ӣ����ǵ�ʱ�Ӿ�����ʱ�����½���
    game_clock game_clock_ (
        .clk(clk),
        .rst(game_clk_rst),
        .pause(mode != `MODE_PLAY),
        .game_clk(game_clk)
    );

    //����һЩ���������Ե�ǰ�����Ľ�������Ļ��״̬������û��ĵ�ǰ����Ҫ��ִ�У���
	 //���磬����û�����������ǽ����Ե�ǰ�������ƶ���λ�ã���x=x-1��
    wire [`BITS_X_POS-1:0] test_pos_x;
    wire [`BITS_Y_POS-1:0] test_pos_y;
    wire [`BITS_ROT-1:0] test_rot;
    // ȷ�����ǲ��Ե�λ��/��ת������߼�������д��һ��ģ���У���������͸����ˡ�
    calc_test_pos_rot calc_test_pos_rot_ (
        .mode(mode),
        .game_clk_rst(game_clk_rst),
        .game_clk(game_clk),
        .btn_left_en(btn_left_en),
        .btn_right_en(btn_right_en),
        .btn_rotate_en(btn_rotate_en),
        .btn_down_en(btn_down_en),
        .btn_drop_en(btn_drop_en),
        .cur_pos_x(cur_pos_x),
        .cur_pos_y(cur_pos_y),
        .cur_rot(cur_rot),
        .test_pos_x(test_pos_x),
        .test_pos_y(test_pos_y),
        .test_rot(test_rot)
    );
    // ���ü������ģ������
    wire [`BITS_BLK_POS-1:0] test_blk_1;
    wire [`BITS_BLK_POS-1:0] test_blk_2;
    wire [`BITS_BLK_POS-1:0] test_blk_3;
    wire [`BITS_BLK_POS-1:0] test_blk_4;
    wire [`BITS_BLK_SIZE-1:0] test_width;
    wire [`BITS_BLK_SIZE-1:0] test_height;
    calc_cur_blk calc_test_block_ (
        .piece(cur_piece),
        .pos_x(test_pos_x),
        .pos_y(test_pos_y),
        .rot(test_rot),
        .blk_1(test_blk_1),
        .blk_2(test_blk_2),
        .blk_3(test_blk_3),
        .blk_4(test_blk_4),
        .width(test_width),
        .height(test_height)
    );

    // �˺�������������λ���Ƿ����κ����µĿ��ཻ��
    function intersects_fallen_pieces;
        input wire [7:0] blk1;
        input wire [7:0] blk2;
        input wire [7:0] blk3;
        input wire [7:0] blk4;
        begin
            intersects_fallen_pieces = fallen_pieces[blk1] ||
                                       fallen_pieces[blk2] ||
                                       fallen_pieces[blk3] ||
                                       fallen_pieces[blk4];
        end
    endfunction

    // ������λ��/��ת��������ཻʱ�����źű�ߡ�
    wire test_intersects = intersects_fallen_pieces(test_blk_1, test_blk_2, test_blk_3, test_blk_4);

    // �жϿ��������ƶ����������ƶ���
    task move_left;
        begin
            if (cur_pos_x > 0 && !test_intersects) begin
                cur_pos_x <= cur_pos_x - 1;
            end
        end
    endtask

    // �жϿ��������ƶ����������ƶ���
    task move_right;
        begin
            if (cur_pos_x + cur_width < `BLOCKS_WIDE && !test_intersects) begin
                cur_pos_x <= cur_pos_x + 1;
            end
        end
    endtask

    // �����ǰ�鲻�ᵼ�¿���κβ����뿪��Ļ���Ҳ������κε���Ŀ��ཻ������ת��ǰ�顣
    task rotate;
        begin
            if (cur_pos_x + test_width <= `BLOCKS_WIDE &&
                cur_pos_y + test_height <= `BLOCKS_HIGH &&
                !test_intersects) begin
                cur_rot <= cur_rot + 1;
            end
        end
    endtask

    // ����ǰ����ӵ�����ķ���
    task add_to_fallen_pieces;
        begin
            fallen_pieces[cur_blk_1] <= 1;
            fallen_pieces[cur_blk_2] <= 1;
            fallen_pieces[cur_blk_3] <= 1;
            fallen_pieces[cur_blk_4] <= 1;
        end
    endtask

    // �������Ŀ���ӵ�����Ŀ��У���Ϊ��������Ļ�������û�ѡ��һ���¿顣
    task get_new_block;
        begin
            // �����½���ʱ����ֱ���㹻�߲����½�
            drop_timer <= 0;
            // Choose a new block for the user
            cur_piece <= random_piece;
            cur_pos_x <= (`BLOCKS_WIDE / 2) - 1;
            cur_pos_y <= 0;
            cur_rot <= 0;
            // ������Ϸ��ʱ����ʹ�û��ڳ�����½�ǰ��һ�����������ڡ�
            game_clk_rst <= 1;
        end
    endtask

    // ����ǰ�������ƶ�һ��������ÿ��뿪�������һ�����ཻ�����ȡһ���¿顣
    task move_down;
        begin
            if (cur_pos_y + cur_height < `BLOCKS_HIGH && !test_intersects) begin
                cur_pos_y <= cur_pos_y + 1;
            end else begin
                add_to_fallen_pieces();
                get_new_block();
            end
        end
    endtask

    // ��ģʽ����Ϊģʽ_drop���ڸ�ģʽ�У���ǰ�鲻����Ӧ�û����룬������ÿ��һ�����ڵ��ٶ������ƶ���ֱ����������ĵײ���
    task drop_to_bottom;
        begin
            mode <= `MODE_DROP;
        end
    endtask

    // �����Ĵ��������û����һ��ʱ����һ����
    reg [3:0] score_1; // 1's place
    reg [3:0] score_2; // 10's place
    reg [3:0] score_3; // 100's place
    reg [3:0] score_4; // 1000's place
    // 7����ʾģ�飬�������
    seg_display score_display_ (
        .clk(clk),
        .score_1(score_1),
        .score_2(score_2),
        .score_3(score_3),
        .score_4(score_4),
        .an(an),
        .seg(seg)
    );
    // ȷ����һ�У�����еĻ����������ģ���Ҫɾ����ģ�飬����������
    wire [`BITS_Y_POS-1:0] remove_row_y;
    wire remove_row_en;
    complete_row complete_row_ (
        .clk(clk),
        .pause(mode != `MODE_PLAY),
        .fallen_pieces(fallen_pieces),
        .row(remove_row_y),
        .enabled(remove_row_en)
    );

    // ������ӵ������Ƭ��ɾ������ɵ���
    // �����ӷ���
    reg [`BITS_Y_POS-1:0] shifting_row;
    task remove_row;
        begin
            // ���ߣ�������
            mode <= `MODE_SHIFT;
            shifting_row <= remove_row_y;
            // ���ӷ���
            if (score_1 == 9) begin
                if (score_2 == 9) begin
                    if (score_3 == 9) begin
                        if (score_4 != 9) begin
                            score_4 <= score_4 + 1;
                            score_3 <= 0;
                            score_2 <= 0;
                            score_1 <= 0;
                        end
                    end else begin
                        score_3 <= score_3 + 1;
                        score_2 <= 0;
                        score_1 <= 0;
                    end
                end else begin
                    score_2 <= score_2 + 1;
                    score_1 <= 0;
                end
            end else begin
                score_1 <= score_1 + 1;
            end
        end
    endtask

    //��ʼ��������Ҫ���κμĴ���
    initial begin
        mode = `MODE_IDLE;
        fallen_pieces = 0;
        cur_piece = `EMPTY_BLOCK;
        cur_pos_x = 0;
        cur_pos_y = 0;
        cur_rot = 0;
        score_1 = 0;
        score_2 = 0;
        score_3 = 0;
        score_4 = 0;
    end

    // ��ģʽ�����С�״̬�°��°�ť��ʼ����Ϸ
    task start_game;
        begin
            mode <= `MODE_PLAY;
            fallen_pieces <= 0;
            score_1 <= 0;
            score_2 <= 0;
            score_3 <= 0;
            score_4 <= 0;
            get_new_block();
        end
    endtask

    // ȷ����Ϸ�Ƿ���ǰλ�ö�����
    // ��׹��ķ����ཻ
    wire game_over = cur_pos_y == 0 && intersects_fallen_pieces(cur_blk_1, cur_blk_2, cur_blk_3, cur_blk_4);

    //��Ϸ���߼�
    always @ (posedge clk) begin
        if (drop_timer < `DROP_TIMER_MAX) begin
            drop_timer <= drop_timer + 1;
        end
        game_clk_rst <= 0;
        if (mode == `MODE_IDLE && (sw_rst_en || sw_rst_dis)) begin
            // ���Ǵ��ڿ���ģʽ���û�������������Ϸ
            start_game();
        end else if (sw_rst_en || sw_rst_dis || game_over) begin
            // �������ÿ��ػ�����Ϸ����ͽ�����
				// �������ģʽ���ȴ��û����°�ť
            mode <= `MODE_IDLE;
            add_to_fallen_pieces();
            cur_piece <= `EMPTY_BLOCK;
        end else if ((sw_pause_en || sw_pause_dis) && mode == `MODE_PLAY) begin
            // ������Ǵ���ͣ�������ģʽ������
            // ��ͣģʽ
            mode <= `MODE_PAUSE;
            old_mode <= mode;
        end else if ((sw_pause_en || sw_pause_dis) && mode == `MODE_PAUSE) begin
            // ������ǹر���ͣ�������ģʽ
            mode <= old_mode;
        end else if (mode == `MODE_PLAY) begin
            // ������Ϸ
            if (game_clk) begin
                move_down();
            end else if (btn_left_en) begin
                move_left();
            end else if (btn_right_en) begin
                move_right();
            end else if (btn_rotate_en) begin
                rotate();
            end else if (btn_down_en) begin
                move_down();
            end else if (btn_drop_en && drop_timer == `DROP_TIMER_MAX) begin
                drop_to_bottom();
            end else if (remove_row_en) begin
                remove_row();
            end
        end else if (mode == `MODE_DROP) begin
            // ����Ҫ�ѷ�����£�ֱ���������¿�ʼ
            // �ڶ���
            if (game_clk_rst && !sw_pause_en) begin
                mode <= `MODE_PLAY;
            end else begin
                move_down();
            end
        end else if (mode == `MODE_SHIFT) begin
            // ����Ҫ���������һ�Ż�����һ��
            // ת�����е�λ��
            if (shifting_row == 0) begin
                fallen_pieces[0 +: `BLOCKS_WIDE] <= 0;
                mode <= `MODE_PLAY;
            end else begin
                fallen_pieces[shifting_row*`BLOCKS_WIDE +: `BLOCKS_WIDE] <= fallen_pieces[(shifting_row - 1)*`BLOCKS_WIDE +: `BLOCKS_WIDE];
                shifting_row <= shifting_row - 1;
            end
        end
    end

endmodule
