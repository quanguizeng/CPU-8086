/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mprog.parser;

import java.io.*;

/**
 *
 * @author Aleksandar
 */
public class MProgParser {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        BufferedReader br = null;
        FileReader fr = null;
        PrintWriter writer = null, writer2 = null;
        int bits[] = new int[77];
        try
        {
            fr = new FileReader("E:\\Faks\\VLSI\\Projekat\\mikroProg.txt");
            br = new BufferedReader(fr);
            writer = new PrintWriter("E:\\Faks\\VLSI\\Projekat\\mikroHex.txt", "UTF-8");
            writer2 = new PrintWriter("E:\\Faks\\VLSI\\Projekat\\mikroHexVHDL.txt", "UTF-8");
            String sCurrentLine;
            int line = 0;

            while ((sCurrentLine = br.readLine()) != null) {
                if (sCurrentLine.startsWith("--"))
                        continue;
                sCurrentLine = sCurrentLine.substring(3);
                for (int i = 0; i < 73; i++)
                    bits[i] = 0;
                String signals[] = sCurrentLine.split(",");
                int code = 0;
                int dst = 0;
                for(String signal: signals)
                {
                    signal = signal.trim();
                    if (signal.equalsIgnoreCase("mx_pc1"))
                        bits[0] = 1;
                    if (signal.equalsIgnoreCase("ld_mar"))
                        bits[1] = 1;
                    if (signal.equalsIgnoreCase("mx_mar1"))
                        bits[2] = 1;
                    if (signal.equalsIgnoreCase("mx_mar0"))
                        bits[3] = 1;
                    if (signal.equalsIgnoreCase("ld_mdr"))
                        bits[4] = 1;
                    if (signal.equalsIgnoreCase("mx_mdr1"))
                        bits[5] = 1;
                    if (signal.equalsIgnoreCase("mx_mdr0"))
                        bits[6] = 1;
                    if (signal.equalsIgnoreCase("ld_ir0"))
                        bits[7] = 1;
                    if (signal.equalsIgnoreCase("ld_ir1"))
                        bits[8] = 1;
                    if (signal.equalsIgnoreCase("ld_ir2"))
                        bits[9] = 1;
                    if (signal.equalsIgnoreCase("ld_pc"))
                        bits[10] = 1;
                    if (signal.equalsIgnoreCase("mx_pc0"))
                        bits[11] = 1;
                    if (signal.equalsIgnoreCase("incPC"))
                        bits[12] = 1;
                    if (signal.equalsIgnoreCase("cl_start"))
                        bits[13] = 1;
                    if (signal.equalsIgnoreCase("ld_dw_l"))
                        bits[14] = 1;
                    if (signal.equalsIgnoreCase("ld_dw_h"))
                        bits[15] = 1;
                    if (signal.equalsIgnoreCase("mx_dw2"))
                        bits[16] = 1;
                    if (signal.equalsIgnoreCase("mx_dw1"))
                        bits[17] = 1;
                    if (signal.equalsIgnoreCase("mx_dw0"))
                        bits[18] = 1;
                    if (signal.equalsIgnoreCase("incSP"))
                        bits[19] = 1;
                    if (signal.equalsIgnoreCase("decSP"))
                        bits[20] = 1;
                    if (signal.equalsIgnoreCase("ld_PSW"))
                        bits[21] = 1;
                    if (signal.equalsIgnoreCase("clr_i"))
                        bits[22] = 1;
                    if (signal.equalsIgnoreCase("set_i"))
                        bits[23] = 1;
                    if (signal.equalsIgnoreCase("clr_c"))
                        bits[24] = 1;
                    if (signal.equalsIgnoreCase("set_c"))
                        bits[25] = 1;
                    if (signal.equalsIgnoreCase("mx_a"))
                        bits[26] = 1;
                    if (signal.equalsIgnoreCase("mx_b1"))
                        bits[27] = 1;
                    if (signal.equalsIgnoreCase("mx_b0"))
                        bits[28] = 1;
                    if (signal.equalsIgnoreCase("dec_cx"))
                        bits[29] = 1;
                    if (signal.equalsIgnoreCase("mem_write"))
                        bits[30] = 1;
                    if (signal.equalsIgnoreCase("ALU_op_code3"))
                        bits[31] = 1;
                    if (signal.equalsIgnoreCase("ALU_op_code2"))
                        bits[32] = 1;
                    if (signal.equalsIgnoreCase("ALU_op_code1"))
                        bits[33] = 1;
                    if (signal.equalsIgnoreCase("ALU_op_code0"))
                        bits[34] = 1;
                    if (signal.equalsIgnoreCase("mx_PSWC2"))
                        bits[35] = 1;
                    if (signal.equalsIgnoreCase("mx_PSWC1"))
                        bits[36] = 1;
                    if (signal.equalsIgnoreCase("mx_PSWC0"))
                        bits[37] = 1;
                    if (signal.equalsIgnoreCase("ld_res"))
                        bits[38] = 1;
                    if (signal.equalsIgnoreCase("ld_flags"))
                        bits[39] = 1;
                    if (signal.equalsIgnoreCase("mx_res"))
                        bits[40] = 1;
                    if (signal.equalsIgnoreCase("ld_dx"))
                        bits[41] = 1;
                    if (signal.equalsIgnoreCase("mx_dx1"))
                        bits[42] = 1;
                    if (signal.equalsIgnoreCase("mx_dx0"))
                        bits[43] = 1;
                    if (signal.equalsIgnoreCase("dec_dx"))
                        bits[44] = 1;
                    if (signal.equalsIgnoreCase("inc_dx"))
                        bits[45] = 1;
                    if (signal.equalsIgnoreCase("ld_ax"))
                        bits[46] = 1;
                    if (signal.equalsIgnoreCase("mx_ax1"))
                        bits[47] = 1;
                    if (signal.equalsIgnoreCase("mx_ax0"))
                        bits[48] = 1;
                    if (signal.equalsIgnoreCase("ld_dw_res"))
                        bits[49] = 1;
                    if (signal.equalsIgnoreCase("ld_dev"))
                        bits[50] = 1;
                    if (signal.equalsIgnoreCase("st_wrong_op_code"))
                        bits[51] = 1;
                    if (signal.equalsIgnoreCase("st_div_zero"))
                        bits[52] = 1;
                    if (signal.equalsIgnoreCase("ld_br"))
                        bits[53] = 1;
                    if (signal.equalsIgnoreCase("mx_br"))
                        bits[54] = 1;
                    if (signal.equalsIgnoreCase("br_in1"))
                        bits[55] = 1;
                    if (signal.equalsIgnoreCase("br_in0"))
                        bits[56] = 1;
                    if (signal.equalsIgnoreCase("inc_mar"))
                        bits[57] = 1;
                    if (signal.equalsIgnoreCase("cl_wrong_op_code"))
                        bits[58] = 1;
                    if (signal.equalsIgnoreCase("cl_wrong_arg"))
                        bits[59] = 1;
                    if (signal.equalsIgnoreCase("cl_div_zero"))
                        bits[60] = 1;
                    
                    if (signal.startsWith("if"))
                    {
                        if (signal.contains("!start"))
                            code = 0;
                        if (signal.contains("one_byte"))
                            code = 1;
                        if (signal.contains("two_byte"))
                            code = 2;
                        if (signal.contains("!PSW_Z"))
                            code = 4;
                        if (signal.contains("PSW_Z"))
                            code = 5;
                        if (signal.contains("PSW_N or PSW_Z"))
                            code = 6;
                        if (signal.contains("PSW_N"))
                            code = 7;
                        if (signal.contains("!PSW_N"))
                            code = 8;
                        if (signal.contains("!PSW_N and !PSW_Z"))
                            code = 9;
                        if (signal.contains("!PSW_P"))
                            code = 10;
                        if (signal.contains("PSW_P"))
                            code = 11;
                        if (signal.contains("!PSW_O"))
                            code = 12;
                        if (signal.contains("PSW_O"))
                            code = 13;
                        if (signal.contains("c_zero"))
                            code = 14;
                        if (signal.contains("c_zero or !PSW_Z"))
                            code = 15;
                        if (signal.contains("c_zero or PSW_Z"))
                            code = 16;
                        if (signal.contains("second_arg_zero"))
                            code = 17;
                        if (signal.contains("!PSW_C"))
                            code = 18;
                        if (signal.contains("!wrong_op_code"))
                            code = 19;
                        if (signal.contains("!wrong_arg"))
                            code = 20;
                        if (signal.contains("!div_zero"))
                            code = 21;
                        if (signal.contains("!interrupt"))
                            code = 22;
                        if (signal.contains("!mem_loaded"))
                            code = 24;
                        
                        String dst_str = (signal.split("br "))[1];
                        dst_str = dst_str.trim();
                        dst = Integer.parseInt(dst_str, 16);
                    }
                    else if (signal.startsWith("br "))
                    {
                        code = 3;
                        String dst_str = (signal.split("br "))[1];
                        dst_str = dst_str.trim();
                        dst = Integer.parseInt(dst_str, 16);
                    }
                    else if (signal.contains("case"))
                        code = 23;
                }
                
                for (int i = 0; i < 8; i ++)
                    bits[61 + i] = (((1 << (7-i)) & code)!= 0)? 1: 0;
                for (int i = 0; i < 8; i++)
                    bits[69 + i] = (((1 << (7-i)) & dst)!= 0)? 1: 0;
                
                writer2.print("ram(" + line + ") <= \"");
                for (int b:bits)
                {
                    writer.print("" + b);
                    writer2.print("" + b);
                }
                writer.println();
                writer2.println("\";");
                line++;
            }
        }
        catch (IOException e){}
        finally
        {
            try {
                if (br != null)
                    br.close();
                if (fr != null)
                    fr.close();
                if (writer != null)
                    writer.close();
                if (writer2 != null)
                    writer2.close();
            }
            catch (IOException ex){}
        }
    }
    
}
