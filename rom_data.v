`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:01:30 05/25/2019 
// Design Name: 
// Module Name:    rom_data 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module rom_data (
    adder    ,
    
    //其他信号,举例dout
    data    );

    //参数定义
    

    //输入信号定义
    input [5:0]          adder  ;
  

    //输出信号定义
    output[1439:0]         data   ;

    //输出信号reg定义
    reg   [1439:0]         data   ;

   

    //组合逻辑写法
    always@(*)begin
        
        case(adder)
			6'd1:   data=1440'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
			6'd2:	  data=1440'h00080000000000C000000020000000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000060000000000040000000400000;
			6'd3:	  data=1440'h001C1800000000700000003800000000060100000080400E0000000100000000000000000000000000000000000000000000000000000000000000000000000000001C0000200020000000000030000000000070000000300000;
			6'd4:	  data=1440'h001C0E000000003800000038000030000380C0000060700F0000000080000000000000000000000000000000000000000000000000000000000000000000000000003C000038003000006000001C000000060060000000380000;
			6'd5:	  data=1440'h00180E000000003C00000031FFFFF8000300C0000070380C00080C00C0000000000000000000000000000000000000000000000000000000000000000000000000003C00003000180000F000001C00001FFF00F00000001C0000;
			6'd6:	  data=1440'h003006000000001C00000030006000000300C0600038381C000FFE00E00000000000000000000600000000000000000000000000000000000000000000000000000033000030001C2107F800000E0000000C00D00002001C0000;
			6'd7:	  data=1440'h00300400C000001C00000830006000000300C0F0001C1C18000C0C4060000000000000006000FE00006000000000000000000000000000000000000000000000000071C00030000871FC0000000C0000000C01C8000200080060;
			6'd8:	  data=1440'h007FFFFFE000001800000E300060001FFFFFFFF8001C1C30000C18404060000007F0FC00F000060000F00000000000000000000000000003F8001F807FF8000FC40060F000300FFFF9C00002000C0030000C01880003FFFFFFF0;
			6'd9:	  data=1440'h00E00C000002000000600E30006000000300C000001C1820000C187FFFF0000001C03000F000060000F000000000000000000000000000060F003040180600303C00E0380030000080C00003FFFFFFF8000C030C000200000060;
			6'd10:	  data=1440'h00E00C000003FFFFFFF00E30006000000300C00002080060000C10C00060000000C0300060000600006000000000000000000000000000080380C030180300601C00C01C30300101C0C000020000007C030C03060006000000C0;
			6'd11:	  data=1440'h01E00C000002000000780E30006000000300C00002000040300C30C000C0000000E02000000006000000000000000000000000000000001803808010180180C00C01801C38300181C0C0000600000060070C0606000E00000080;
			6'd12:	  data=1440'h03600C030006000000C00630C06030000300C00007FFFFFFF80C21C000800000006060000000060000000000000000000000000000000030018180181800C1800401800C303000C180C000060C0400C0060C0C03000E00000500;
			6'd13:	  data=1440'h067FFFFF8006000001800630FFFFF8010000000006000000780C218000000000007040000000060000000000000000000000000000000030008300081800C18006030000303000E300C0000E07070080060C0C01800000000E00;
			6'd14:	  data=1440'h0C600C00000E000001000630C0603000C000020006000000600C4000060000000030C00000000600000000000000000000000000000000300083000C1800C30002020000303000E300C0001E0387810006181801E001FFFFFF00;
			6'd15:	  data=1440'h08600C00000C000002000630C0603000702007000E000000C00C403FFF0000000038800000000600000000000000000000000000000000300003000C1800C300000700603030004200C010000387000006183002F80000700000;
			6'd16:	  data=1440'h30600C030000000000C00630C0603000313FFF800E000000800C400000000000001980002000060000200000000000000000000000000038000200041800C300000DFFF03030004418C0380001C70000061820037C0000C04000;
			6'd17:	  data=1440'h007FFFFF8000000001E00630C0603000323003001E000019000C200000000000001D000FE00006000FE00087C03F9F80000000000000001C000600061800C6000019806030303FFFFCFFFC000187000006185FFFB00001803000;
			6'd18:	  data=1440'h00600C00000FFFFFFFF00630C060300002300300007FFFFC000C100000000000000F00006000060000600798700E0600000000000000001E0006000618018600001180603030000C00C18000C087000006198000000007001C00;
			6'd19:	  data=1440'h00600C000000001800000630C0603018043003000000003E000C180000400000000E000060000600006001E03006040000000000000000078006000618030600002180E03030000C00C18000700700000C1A000000000C000E00;
			6'd20:	  data=1440'h00600C008000001800000630C060300E0430030000000060000C0C0000E000000006000060000600006001C018070C0000007FFFE0000001F0060006180E0600000180E03030000C00C18000380600000C1F8000000038000F00;
			6'd21:	  data=1440'h00600C01C000001800000630C06030070430070000000180000C0CFFFFF000000006000060000600006001801803880000000000000000007C0600061FF80600000180E03030000C00C180003C0600001FFF81008000FFFFFF00;
			6'd22:	  data=1440'h007FFFFFE000001800000630C06030038830070000000300000C0606300000000007000060000600006001801801900000000000000000001E06000618000600000180E03030000C31C180001C0600000C030080E0007FF00300;
			6'd23:	  data=1440'h006010000000001800000630C06030010830070000001C00000C060630000000000F000060000600006001801801F00000000000000000000706000618000600000180C030300FFFF9C180001C060000000320C0E00070000300;
			6'd24:	  data=1440'h00601C000000001800000E30C06030001030060000001C00600C060630000000000B800060000600006001801800E00000000000000000000386000618000600000180C03030000C01818000080E0020000310C0C00000100000;
			6'd25:	  data=1440'h000018001000001800000E70C06030001030060000001C00F00C0606300000000019800060000600006001801800E000000000000000000001C6000618000600000191C03030000C01818000080E007000031861C000001C0000;
			6'd26:	  data=1440'h000018003800001800000E60C0603000303006001FFFFFFFF80C0E06300000000011C00060000600006001801800F000000000000000000000C200041800060000018FC03030010D0181801FFFFFFFF800031861800000180000;
			6'd27:	  data=1440'h3FFFFFFFFC00001800000860C06030006030FE0000001C00000CFC0E300000000030C00060000600006001801800B000000000000000002000C3000C1800030000018384003003CC81818000000C000000FE1C71800000180000;
			6'd28:	  data=1440'h0000FA000000001800000060C060700860303E1000001C00000C3C0C301000000020E000600006000060018018013800000000000000002000C3000C18000300020183040030038CE1818000001C00007F860C71000000180600;
			6'd29:	  data=1440'h0001D90000000018000000C0C063E007E0301C1000001C00000C300C301000000060E000600006000060018018031800000000000000003000C1000C18000300040180040030030C73018000001C00003C060C730000FFFFFF00;
			6'd30:	  data=1440'h000398C000000018000000C0C060E001C030001000001C00000C001C3010000000407000600006000060018018020C00000000000000001000C1801818000180040180040030060C33018000003B800010060C73000000180000;
			6'd31:	  data=1440'h0006186000000018000001800060C000C030003000001C00000C00183010000000C07000600006000060018018040E0000000000000000180180801018000180080180040030060C330180000070F00000060C02000000180000;
			6'd32:	  data=1440'h001C1830000000180000018000600000C030003000001C00000C003830100000008030006000060000600180180C0600000000000000001C01004030180000C01001800600300C0C3601800000E03C0000060C06000000180000;
			6'd33:	  data=1440'h0038181C000000180000030000600000C030003800001C00000C007030100000018038006000060000600180181C0700000000000000001F060030C0180000306001800E0030080C0C01800001C01F00000C0004000000180000;
			6'd34:	  data=1440'h00E0180F800000380000060000600000C03FFFF800001C00000C00E03838000007E0FE0FFF00FFF00FFF07E07E7E1FC00000000000000010FC001F80FF00000FC001FFFE1FF0101C08018000038007C0079C0004100000180030;
			6'd35:	  data=1440'h01801803FC000FF80000040000600000C01FFFF00007FC00000C01801FF8000000000000000000000000000000000000000000000000000000000000000000000000FFFC07F021FC180180000E0003C000FC0008380000180078;
			6'd36:	  data=1440'h06001800F80001F80000080000600000C00000000000F800000C03001FF0000000000000000000000000000000000000000000000000000000000000000000000000000001E0007830018000380001C00078FFFFFC1FFFFFFFFC;
			6'd37:	  data=1440'h38001800300000700000100000600000C000000000007000000C0C00000000000000000000000000000000000000000000000000000000000000000000000000000000000080003040038003C00000C000200000000000000000;
			6'd38:	  data=1440'h0000100000000040000020000040000000000000000020000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008003001C0000000000000000000000000000;
			6'd39:	  data=1440'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      default:   data=1440'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

      endcase
    
   end
   endmodule
