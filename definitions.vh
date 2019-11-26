// ��Ļ���
`define PIXEL_WIDTH 1024
// ��Ļ����
`define PIXEL_HEIGHT 768

// ����VGAˮƽ�ʹ�ֱͬ��
`define HSYNC_FRONT_PORCH 24
`define HSYNC_PULSE_WIDTH 136
`define HSYNC_BACK_PORCH 160
`define VSYNC_FRONT_PORCH 3
`define VSYNC_PULSE_WIDTH 6
`define VSYNC_BACK_PORCH 29

// ÿ�����ж������ؿ�/��
`define BLOCK_SIZE 30

// ��Ϸ������һ���ж��ٿ�
`define BLOCKS_WIDE 10

// ��Ϸ���������λ���ٿ�
`define BLOCKS_HIGH 22

// ��Ϸ��Ŀ�ȣ����أ�
`define BOARD_WIDTH (`BLOCKS_WIDE * `BLOCK_SIZE)
// �����ʼλ��(x)
`define BOARD_X (((`PIXEL_WIDTH - `BOARD_WIDTH) / 2) - 1)

// ��Ϸ��ĸ߶�(���أ�
`define BOARD_HEIGHT (`BLOCKS_HIGH * `BLOCK_SIZE)
// ����ĳ�ʼλ��(y)
`define BOARD_Y (((`PIXEL_HEIGHT - `BOARD_HEIGHT) / 2) - 1)

// ���ڴ洢��λ�õ�λ����
`define BITS_BLK_POS 8
// ���ڴ洢Xλ�õ�λ����
`define BITS_X_POS 4
// ���ڴ洢Yλ�õ�λ��
`define BITS_Y_POS 5
// ���ڴ洢��ת��λ��
`define BITS_ROT 2
// ���ڴ洢��Ŀ��/���ȵ�λ�������ֵΪʮ����4��
`define BITS_BLK_SIZE 3
// ������λ���� �÷�������9999
`define BITS_SCORE 14
// ���ڴ洢��ֹ�����λ��
`define BITS_PER_BLOCK 3

// ÿ���������
`define EMPTY_BLOCK 3'b000
`define I_BLOCK 3'b001
`define O_BLOCK 3'b010
`define T_BLOCK 3'b011
`define S_BLOCK 3'b100
`define Z_BLOCK 3'b101
`define J_BLOCK 3'b110
`define L_BLOCK 3'b111

// �����ɫ��ֵ
`define WHITE 8'b11111111
`define BLACK 8'b00000000
`define GRAY 8'b10100100
`define CYAN 8'b11110000
`define YELLOW 8'b00111111
`define PURPLE 8'b11000111
`define GREEN 8'b00111000
`define RED 8'b00000111
`define BLUE 8'b11000000
`define ORANGE 8'b00011111

// �������
`define ERR_BLK_POS 8'b11111111

// ״̬��ģʽѡ��
`define MODE_BITS 3
`define MODE_PLAY 0
`define MODE_DROP 1
`define MODE_PAUSE 2
`define MODE_IDLE 3
`define MODE_SHIFT 4

// �½���ʱ�������ֵ
`define DROP_TIMER_MAX 10000
