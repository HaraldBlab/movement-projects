library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity circle_stage_tb is
end circle_stage_tb;

architecture sim of circle_stage_tb is

    constant clk_hz : integer := 12e6;
    constant clk_period : time := 1 sec / clk_hz;
    constant cnt_bits : integer := 25;
    constant step_bits : positive := 8;

    signal clk : std_logic := '1';
    signal rst_n : std_logic := '0';
    signal pwm : std_logic_vector(2 downto 0);

    constant step_count : positive := 2**step_bits;
    -- test stimulus
    type stimulus_data is array (0 to 2) of integer range 0 to step_count - 1; 
    type stimulus_data_array is array(1 to 255) of stimulus_data;
    signal test_angle : stimulus_data_array := (
      ( 0, 85, 170 ),   ( 1, 86, 171 ),   ( 2, 87, 172 ),   ( 3, 88, 173 ),
      ( 4, 89, 174 ),   ( 5, 90, 175 ),   ( 6, 91, 176 ),   ( 7, 92, 177 ),
      ( 8, 93, 178 ),   ( 9, 94, 179 ),   ( 10, 95, 180 ),   ( 10, 96, 181 ),
      ( 12, 97, 182 ),   ( 13, 98, 183 ),   ( 14, 99, 184 ),   ( 14, 100, 185 ),
      ( 16, 101, 186 ),   ( 17, 102, 187 ),   ( 18, 103, 188 ),   ( 19, 104, 189 ),
      ( 20, 105, 190 ),   ( 21, 106, 191 ),   ( 21, 107, 192 ),   ( 23, 108, 193 ),
      ( 24, 109, 194 ),   ( 25, 110, 195 ),   ( 26, 111, 196 ),   ( 27, 112, 197 ),
      ( 28, 113, 198 ),   ( 29, 114, 199 ),   ( 29, 115, 200 ),   ( 31, 116, 201 ),
      ( 32, 117, 202 ),   ( 33, 118, 203 ),   ( 34, 119, 204 ),   ( 35, 120, 205 ),
      ( 36, 121, 206 ),   ( 37, 122, 207 ),   ( 38, 123, 208 ),   ( 39, 124, 209 ),
      ( 40, 125, 210 ),   ( 41, 126, 211 ),   ( 42, 127, 212 ),   ( 43, 128, 213 ),
      ( 43, 129, 214 ),   ( 45, 130, 215 ),   ( 46, 131, 216 ),   ( 47, 132, 217 ),
      ( 48, 133, 218 ),   ( 49, 134, 219 ),   ( 50, 135, 220 ),   ( 51, 136, 221 ),
      ( 52, 137, 222 ),   ( 53, 138, 223 ),   ( 54, 139, 224 ),   ( 55, 140, 225 ),
      ( 56, 141, 226 ),   ( 57, 142, 227 ),   ( 58, 143, 228 ),   ( 59, 144, 229 ),
      ( 59, 145, 230 ),   ( 61, 146, 231 ),   ( 62, 147, 232 ),   ( 63, 148, 233 ),
      ( 64, 149, 234 ),   ( 65, 150, 235 ),   ( 66, 151, 236 ),   ( 67, 152, 237 ),
      ( 68, 153, 238 ),   ( 69, 154, 239 ),   ( 70, 155, 240 ),   ( 71, 156, 241 ),
      ( 72, 157, 242 ),   ( 73, 158, 243 ),   ( 74, 159, 244 ),   ( 75, 160, 245 ),
      ( 76, 161, 246 ),   ( 77, 162, 247 ),   ( 78, 163, 248 ),   ( 79, 164, 249 ),
      ( 80, 165, 250 ),   ( 81, 166, 251 ),   ( 82, 167, 252 ),   ( 83, 168, 253 ),
      ( 84, 169, 254 ),   ( 85, 170, 255 ),   ( 86, 171, 0 ),   ( 87, 172, 1 ),
      ( 87, 173, 2 ),   ( 89, 174, 3 ),   ( 90, 175, 4 ),   ( 91, 176, 5 ),
      ( 92, 177, 6 ),   ( 92, 178, 7 ),   ( 94, 179, 8 ),   ( 95, 180, 9 ),
      ( 96, 181, 10 ),   ( 97, 182, 11 ),   ( 98, 183, 12 ),   ( 99, 184, 13 ),
      ( 100, 185, 14 ),   ( 101, 186, 15 ),   ( 102, 187, 16 ),   ( 103, 188, 17 ),
      ( 104, 189, 18 ),   ( 105, 190, 19 ),   ( 106, 191, 20 ),   ( 107, 192, 21 ),
      ( 108, 193, 22 ),   ( 108, 194, 23 ),   ( 110, 195, 24 ),   ( 111, 196, 25 ),
      ( 112, 197, 26 ),   ( 113, 198, 27 ),   ( 114, 199, 28 ),   ( 115, 200, 29 ),
      ( 116, 201, 30 ),   ( 117, 202, 31 ),   ( 118, 203, 32 ),   ( 119, 204, 33 ),
      ( 119, 205, 34 ),   ( 121, 206, 35 ),   ( 122, 207, 36 ),   ( 123, 208, 37 ),
      ( 124, 209, 38 ),   ( 124, 210, 39 ),   ( 126, 211, 40 ),   ( 127, 212, 41 ),
      ( 128, 213, 42 ),   ( 129, 214, 43 ),   ( 130, 215, 44 ),   ( 131, 216, 45 ),
      ( 132, 217, 46 ),   ( 133, 218, 47 ),   ( 134, 219, 48 ),   ( 135, 220, 49 ),
      ( 136, 221, 50 ),   ( 137, 222, 51 ),   ( 138, 223, 52 ),   ( 139, 224, 53 ),
      ( 140, 225, 54 ),   ( 141, 226, 55 ),   ( 142, 227, 56 ),   ( 143, 228, 57 ),
      ( 144, 229, 58 ),   ( 145, 230, 59 ),   ( 146, 231, 60 ),   ( 147, 232, 61 ),
      ( 148, 233, 62 ),   ( 149, 234, 63 ),   ( 150, 235, 64 ),   ( 151, 236, 65 ),
      ( 152, 237, 66 ),   ( 153, 238, 67 ),   ( 154, 239, 68 ),   ( 155, 240, 69 ),
      ( 156, 241, 70 ),   ( 157, 242, 71 ),   ( 158, 243, 72 ),   ( 159, 244, 73 ),
      ( 160, 245, 74 ),   ( 161, 246, 75 ),   ( 162, 247, 76 ),   ( 163, 248, 77 ),
      ( 164, 249, 78 ),   ( 164, 250, 79 ),   ( 166, 251, 80 ),   ( 167, 252, 81 ),
      ( 168, 253, 82 ),   ( 169, 254, 83 ),   ( 170, 255, 84 ),   ( 171, 0, 85 ),
      ( 172, 1, 86 ),   ( 173, 2, 87 ),   ( 174, 3, 88 ),   ( 174, 4, 89 ),
      ( 175, 5, 90 ),   ( 177, 6, 91 ),   ( 178, 7, 92 ),   ( 179, 8, 93 ),
      ( 180, 9, 94 ),   ( 181, 10, 95 ),   ( 182, 11, 96 ),   ( 183, 12, 97 ),
      ( 184, 13, 98 ),   ( 185, 14, 99 ),   ( 185, 15, 100 ),   ( 187, 16, 101 ),
      ( 188, 17, 102 ),   ( 189, 18, 103 ),   ( 190, 19, 104 ),   ( 191, 20, 105 ),
      ( 192, 21, 106 ),   ( 193, 22, 107 ),   ( 194, 23, 108 ),   ( 195, 24, 109 ),
      ( 196, 25, 110 ),   ( 196, 26, 111 ),   ( 198, 27, 112 ),   ( 199, 28, 113 ),
      ( 200, 29, 114 ),   ( 201, 30, 115 ),   ( 202, 31, 116 ),   ( 203, 32, 117 ),
      ( 204, 33, 118 ),   ( 205, 34, 119 ),   ( 206, 35, 120 ),   ( 206, 36, 121 ),
      ( 208, 37, 122 ),   ( 209, 38, 123 ),   ( 210, 39, 124 ),   ( 211, 40, 125 ),
      ( 212, 41, 126 ),   ( 213, 42, 127 ),   ( 214, 43, 128 ),   ( 215, 44, 129 ),
      ( 216, 45, 130 ),   ( 217, 46, 131 ),   ( 217, 47, 132 ),   ( 219, 48, 133 ),
      ( 220, 49, 134 ),   ( 221, 50, 135 ),   ( 222, 51, 136 ),   ( 223, 52, 137 ),
      ( 224, 53, 138 ),   ( 225, 54, 139 ),   ( 226, 55, 140 ),   ( 227, 56, 141 ),
      ( 228, 57, 142 ),   ( 228, 58, 143 ),   ( 230, 59, 144 ),   ( 231, 60, 145 ),
      ( 232, 61, 146 ),   ( 233, 62, 147 ),   ( 234, 63, 148 ),   ( 235, 64, 149 ),
      ( 236, 65, 150 ),   ( 237, 66, 151 ),   ( 238, 67, 152 ),   ( 238, 68, 153 ),
      ( 239, 69, 154 ),   ( 241, 70, 155 ),   ( 242, 71, 156 ),   ( 243, 72, 157 ),
      ( 244, 73, 158 ),   ( 245, 74, 159 ),   ( 246, 75, 160 ),   ( 247, 76, 161 ),
      ( 248, 77, 162 ),   ( 249, 78, 163 ),   ( 249, 79, 164 ),   ( 251, 80, 165 ),
      ( 252, 81, 166 ),   ( 253, 82, 167 ),   ( 254, 83, 168 )
    );
    signal test_sin : stimulus_data_array := (
      ( 128, 238, 17 ),   ( 131, 237, 15 ),   ( 134, 235, 14 ),   ( 137, 233, 12 ),
      ( 140, 232, 11 ),   ( 143, 230, 10 ),   ( 146, 228, 8 ),   ( 149, 226, 7 ),
      ( 152, 224, 6 ),   ( 156, 222, 5 ),   ( 159, 219, 4 ),   ( 162, 217, 4 ),
      ( 165, 215, 3 ),   ( 168, 213, 2 ),   ( 171, 210, 2 ),   ( 174, 208, 1 ),
      ( 176, 205, 1 ),   ( 179, 203, 0 ),   ( 182, 200, 0 ),   ( 185, 198, 0 ),
      ( 188, 195, 0 ),   ( 191, 192, 0 ),   ( 193, 190, 0 ),   ( 196, 187, 0 ),
      ( 199, 184, 0 ),   ( 201, 181, 0 ),   ( 204, 178, 0 ),   ( 206, 176, 1 ),
      ( 209, 173, 1 ),   ( 211, 170, 2 ),   ( 213, 167, 2 ),   ( 216, 164, 3 ),
      ( 218, 161, 4 ),   ( 220, 158, 5 ),   ( 222, 155, 6 ),   ( 224, 151, 7 ),
      ( 226, 148, 8 ),   ( 228, 145, 9 ),   ( 230, 142, 10 ),   ( 232, 139, 11 ),
      ( 234, 136, 13 ),   ( 236, 133, 14 ),   ( 237, 130, 16 ),   ( 239, 126, 17 ),
      ( 240, 123, 19 ),   ( 242, 120, 20 ),   ( 243, 117, 22 ),   ( 245, 114, 24 ),
      ( 246, 111, 26 ),   ( 247, 108, 28 ),   ( 248, 105, 30 ),   ( 249, 102, 32 ),
      ( 250, 98, 34 ),   ( 251, 95, 36 ),   ( 252, 92, 38 ),   ( 252, 89, 41 ),
      ( 253, 86, 43 ),   ( 254, 83, 45 ),   ( 254, 80, 48 ),   ( 255, 78, 50 ),
      ( 255, 75, 53 ),   ( 255, 72, 56 ),   ( 255, 69, 58 ),   ( 255, 66, 61 ),
      ( 0, 64, 63 ),   ( 255, 61, 66 ),   ( 255, 58, 69 ),   ( 255, 56, 72 ),
      ( 255, 53, 75 ),   ( 255, 50, 78 ),   ( 254, 48, 80 ),   ( 254, 45, 83 ),
      ( 253, 43, 86 ),   ( 252, 41, 89 ),   ( 252, 38, 92 ),   ( 251, 36, 95 ),
      ( 250, 34, 98 ),   ( 249, 32, 102 ),   ( 248, 30, 105 ),   ( 247, 28, 108 ),
      ( 246, 26, 111 ),   ( 245, 24, 114 ),   ( 243, 22, 117 ),   ( 242, 20, 120 ),
      ( 240, 19, 123 ),   ( 239, 17, 126 ),   ( 237, 16, 130 ),   ( 236, 14, 133 ),
      ( 234, 13, 136 ),   ( 232, 11, 139 ),   ( 230, 10, 142 ),   ( 228, 9, 145 ),
      ( 226, 8, 148 ),   ( 224, 7, 151 ),   ( 222, 6, 155 ),   ( 220, 5, 158 ),
      ( 218, 4, 161 ),   ( 216, 3, 164 ),   ( 213, 2, 167 ),   ( 211, 2, 170 ),
      ( 209, 1, 173 ),   ( 206, 1, 176 ),   ( 204, 0, 178 ),   ( 201, 0, 181 ),
      ( 199, 0, 184 ),   ( 196, 0, 187 ),   ( 193, 0, 190 ),   ( 191, 0, 192 ),
      ( 188, 0, 195 ),   ( 185, 0, 198 ),   ( 182, 0, 200 ),   ( 179, 0, 203 ),
      ( 176, 1, 205 ),   ( 174, 1, 208 ),   ( 171, 2, 210 ),   ( 168, 2, 213 ),
      ( 165, 3, 215 ),   ( 162, 4, 217 ),   ( 159, 4, 219 ),   ( 156, 5, 222 ),
      ( 152, 6, 224 ),   ( 149, 7, 226 ),   ( 146, 8, 228 ),   ( 143, 10, 230 ),
      ( 140, 11, 232 ),   ( 137, 12, 233 ),   ( 134, 14, 235 ),   ( 131, 15, 237 ),
      ( 128, 17, 238 ),   ( 124, 18, 240 ),   ( 121, 20, 241 ),   ( 118, 22, 243 ),
      ( 115, 23, 244 ),   ( 112, 25, 245 ),   ( 109, 27, 247 ),   ( 106, 29, 248 ),
      ( 103, 31, 249 ),   ( 99, 33, 250 ),   ( 96, 36, 251 ),   ( 93, 38, 251 ),
      ( 90, 40, 252 ),   ( 87, 42, 253 ),   ( 84, 45, 253 ),   ( 81, 47, 254 ),
      ( 79, 50, 254 ),   ( 76, 52, 255 ),   ( 73, 55, 255 ),   ( 70, 57, 255 ),
      ( 67, 60, 255 ),   ( 64, 63, 255 ),   ( 62, 65, 255 ),   ( 59, 68, 255 ),
      ( 56, 71, 255 ),   ( 54, 74, 255 ),   ( 51, 77, 255 ),   ( 49, 79, 254 ),
      ( 46, 82, 254 ),   ( 44, 85, 253 ),   ( 42, 88, 253 ),   ( 39, 91, 252 ),
      ( 37, 94, 251 ),   ( 35, 97, 250 ),   ( 33, 100, 249 ),   ( 31, 104, 248 ),
      ( 29, 107, 247 ),   ( 27, 110, 246 ),   ( 25, 113, 245 ),   ( 23, 116, 244 ),
      ( 21, 119, 242 ),   ( 19, 122, 241 ),   ( 18, 125, 239 ),   ( 16, 129, 238 ),
      ( 15, 132, 236 ),   ( 13, 135, 235 ),   ( 12, 138, 233 ),   ( 10, 141, 231 ),
      ( 9, 144, 229 ),   ( 8, 147, 227 ),   ( 7, 150, 225 ),   ( 6, 153, 223 ),
      ( 5, 157, 221 ),   ( 4, 160, 219 ),   ( 3, 163, 217 ),   ( 3, 166, 214 ),
      ( 2, 169, 212 ),   ( 1, 172, 210 ),   ( 1, 175, 207 ),   ( 0, 177, 205 ),
      ( 0, 180, 202 ),   ( 0, 183, 199 ),   ( 0, 186, 197 ),   ( 0, 189, 194 ),
      ( 0, 191, 191 ),   ( 0, 194, 189 ),   ( 0, 197, 186 ),   ( 0, 199, 183 ),
      ( 0, 202, 180 ),   ( 0, 205, 177 ),   ( 1, 207, 175 ),   ( 1, 210, 172 ),
      ( 2, 212, 169 ),   ( 3, 214, 166 ),   ( 3, 217, 163 ),   ( 4, 219, 160 ),
      ( 5, 221, 157 ),   ( 6, 223, 153 ),   ( 7, 225, 150 ),   ( 8, 227, 147 ),
      ( 9, 229, 144 ),   ( 10, 231, 141 ),   ( 12, 233, 138 ),   ( 13, 235, 135 ),
      ( 15, 236, 132 ),   ( 16, 238, 129 ),   ( 18, 239, 125 ),   ( 19, 241, 122 ),
      ( 21, 242, 119 ),   ( 23, 244, 116 ),   ( 25, 245, 113 ),   ( 27, 246, 110 ),
      ( 29, 247, 107 ),   ( 31, 248, 104 ),   ( 33, 249, 100 ),   ( 35, 250, 97 ),
      ( 37, 251, 94 ),   ( 39, 252, 91 ),   ( 42, 253, 88 ),   ( 44, 253, 85 ),
      ( 46, 254, 82 ),   ( 49, 254, 79 ),   ( 51, 255, 77 ),   ( 54, 255, 74 ),
      ( 56, 255, 71 ),   ( 59, 255, 68 ),   ( 62, 255, 65 ),   ( 64, 255, 63 ),
      ( 67, 255, 60 ),   ( 70, 255, 57 ),   ( 73, 255, 55 ),   ( 76, 255, 52 ),
      ( 79, 254, 50 ),   ( 81, 254, 47 ),   ( 84, 253, 45 ),   ( 87, 253, 42 ),
      ( 90, 252, 40 ),   ( 93, 251, 38 ),   ( 96, 251, 36 ),   ( 99, 250, 33 ),
      ( 103, 249, 31 ),   ( 106, 248, 29 ),   ( 109, 247, 27 ),   ( 112, 245, 25 ),
      ( 115, 244, 23 ),   ( 118, 243, 22 ),   ( 121, 241, 20 )
    );
    signal test_position : stimulus_data_array := (
      ( 128, 164, 91 ),   ( 129, 164, 90 ),   ( 130, 163, 90 ),   ( 131, 163, 89 ),
      ( 132, 162, 89 ),   ( 133, 162, 88 ),   ( 134, 161, 88 ),   ( 135, 160, 87 ),
      ( 136, 160, 87 ),   ( 137, 159, 87 ),   ( 138, 158, 86 ),   ( 139, 157, 86 ),
      ( 140, 157, 86 ),   ( 141, 156, 86 ),   ( 142, 155, 86 ),   ( 143, 154, 85 ),
      ( 144, 153, 85 ),   ( 145, 153, 85 ),   ( 146, 152, 85 ),   ( 147, 151, 85 ),
      ( 148, 150, 85 ),   ( 149, 149, 85 ),   ( 149, 148, 85 ),   ( 150, 147, 85 ),
      ( 151, 146, 85 ),   ( 152, 145, 85 ),   ( 153, 144, 85 ),   ( 154, 144, 85 ),
      ( 155, 143, 85 ),   ( 155, 142, 86 ),   ( 156, 141, 86 ),   ( 157, 140, 86 ),
      ( 158, 139, 86 ),   ( 158, 138, 87 ),   ( 159, 137, 87 ),   ( 160, 135, 87 ),
      ( 160, 134, 88 ),   ( 161, 133, 88 ),   ( 162, 132, 88 ),   ( 162, 131, 89 ),
      ( 163, 130, 89 ),   ( 164, 129, 90 ),   ( 164, 128, 90 ),   ( 165, 127, 91 ),
      ( 165, 126, 91 ),   ( 166, 125, 92 ),   ( 166, 124, 92 ),   ( 167, 123, 93 ),
      ( 167, 122, 94 ),   ( 167, 121, 94 ),   ( 168, 120, 95 ),   ( 168, 119, 96 ),
      ( 168, 118, 96 ),   ( 169, 117, 97 ),   ( 169, 116, 98 ),   ( 169, 115, 99 ),
      ( 169, 114, 99 ),   ( 170, 113, 100 ),   ( 170, 112, 101 ),   ( 170, 111, 102 ),
      ( 170, 110, 103 ),   ( 170, 109, 104 ),   ( 170, 108, 104 ),   ( 170, 107, 105 ),
      ( 170, 106, 106 ),   ( 170, 105, 107 ),   ( 170, 104, 108 ),   ( 170, 104, 109 ),
      ( 170, 103, 110 ),   ( 170, 102, 111 ),   ( 170, 101, 112 ),   ( 170, 100, 113 ),
      ( 169, 99, 114 ),   ( 169, 99, 115 ),   ( 169, 98, 116 ),   ( 169, 97, 117 ),
      ( 168, 96, 118 ),   ( 168, 96, 119 ),   ( 168, 95, 120 ),   ( 167, 94, 121 ),
      ( 167, 94, 122 ),   ( 167, 93, 123 ),   ( 166, 92, 124 ),   ( 166, 92, 125 ),
      ( 165, 91, 126 ),   ( 165, 91, 127 ),   ( 164, 90, 128 ),   ( 164, 90, 129 ),
      ( 163, 89, 130 ),   ( 162, 89, 131 ),   ( 162, 88, 132 ),   ( 161, 88, 133 ),
      ( 160, 88, 134 ),   ( 160, 87, 135 ),   ( 159, 87, 137 ),   ( 158, 87, 138 ),
      ( 158, 86, 139 ),   ( 157, 86, 140 ),   ( 156, 86, 141 ),   ( 155, 86, 142 ),
      ( 155, 85, 143 ),   ( 154, 85, 144 ),   ( 153, 85, 144 ),   ( 152, 85, 145 ),
      ( 151, 85, 146 ),   ( 150, 85, 147 ),   ( 149, 85, 148 ),   ( 149, 85, 149 ),
      ( 148, 85, 150 ),   ( 147, 85, 151 ),   ( 146, 85, 152 ),   ( 145, 85, 153 ),
      ( 144, 85, 153 ),   ( 143, 85, 154 ),   ( 142, 86, 155 ),   ( 141, 86, 156 ),
      ( 140, 86, 157 ),   ( 139, 86, 157 ),   ( 138, 86, 158 ),   ( 137, 87, 159 ),
      ( 136, 87, 160 ),   ( 135, 87, 160 ),   ( 134, 88, 161 ),   ( 133, 88, 162 ),
      ( 132, 89, 162 ),   ( 131, 89, 163 ),   ( 130, 90, 163 ),   ( 129, 90, 164 ),
      ( 128, 91, 164 ),   ( 126, 91, 165 ),   ( 125, 92, 165 ),   ( 124, 92, 166 ),
      ( 123, 93, 166 ),   ( 122, 93, 167 ),   ( 121, 94, 167 ),   ( 120, 95, 168 ),
      ( 119, 95, 168 ),   ( 118, 96, 168 ),   ( 117, 97, 169 ),   ( 116, 98, 169 ),
      ( 115, 98, 169 ),   ( 114, 99, 169 ),   ( 113, 100, 169 ),   ( 112, 101, 170 ),
      ( 111, 102, 170 ),   ( 110, 102, 170 ),   ( 109, 103, 170 ),   ( 108, 104, 170 ),
      ( 107, 105, 170 ),   ( 106, 106, 170 ),   ( 106, 107, 170 ),   ( 105, 108, 170 ),
      ( 104, 109, 170 ),   ( 103, 110, 170 ),   ( 102, 111, 170 ),   ( 101, 111, 170 ),
      ( 100, 112, 170 ),   ( 100, 113, 169 ),   ( 99, 114, 169 ),   ( 98, 115, 169 ),
      ( 97, 116, 169 ),   ( 97, 117, 168 ),   ( 96, 118, 168 ),   ( 95, 120, 168 ),
      ( 95, 121, 167 ),   ( 94, 122, 167 ),   ( 93, 123, 167 ),   ( 93, 124, 166 ),
      ( 92, 125, 166 ),   ( 91, 126, 165 ),   ( 91, 127, 165 ),   ( 90, 128, 164 ),
      ( 90, 129, 164 ),   ( 89, 130, 163 ),   ( 89, 131, 163 ),   ( 88, 132, 162 ),
      ( 88, 133, 161 ),   ( 88, 134, 161 ),   ( 87, 135, 160 ),   ( 87, 136, 159 ),
      ( 87, 137, 159 ),   ( 86, 138, 158 ),   ( 86, 139, 157 ),   ( 86, 140, 156 ),
      ( 86, 141, 156 ),   ( 85, 142, 155 ),   ( 85, 143, 154 ),   ( 85, 144, 153 ),
      ( 85, 145, 152 ),   ( 85, 146, 151 ),   ( 85, 147, 151 ),   ( 85, 148, 150 ),
      ( 85, 149, 149 ),   ( 85, 150, 148 ),   ( 85, 151, 147 ),   ( 85, 151, 146 ),
      ( 85, 152, 145 ),   ( 85, 153, 144 ),   ( 85, 154, 143 ),   ( 85, 155, 142 ),
      ( 86, 156, 141 ),   ( 86, 156, 140 ),   ( 86, 157, 139 ),   ( 86, 158, 138 ),
      ( 87, 159, 137 ),   ( 87, 159, 136 ),   ( 87, 160, 135 ),   ( 88, 161, 134 ),
      ( 88, 161, 133 ),   ( 88, 162, 132 ),   ( 89, 163, 131 ),   ( 89, 163, 130 ),
      ( 90, 164, 129 ),   ( 90, 164, 128 ),   ( 91, 165, 127 ),   ( 91, 165, 126 ),
      ( 92, 166, 125 ),   ( 93, 166, 124 ),   ( 93, 167, 123 ),   ( 94, 167, 122 ),
      ( 95, 167, 121 ),   ( 95, 168, 120 ),   ( 96, 168, 118 ),   ( 97, 168, 117 ),
      ( 97, 169, 116 ),   ( 98, 169, 115 ),   ( 99, 169, 114 ),   ( 100, 169, 113 ),
      ( 100, 170, 112 ),   ( 101, 170, 111 ),   ( 102, 170, 111 ),   ( 103, 170, 110 ),
      ( 104, 170, 109 ),   ( 105, 170, 108 ),   ( 106, 170, 107 ),   ( 106, 170, 106 ),
      ( 107, 170, 105 ),   ( 108, 170, 104 ),   ( 109, 170, 103 ),   ( 110, 170, 102 ),
      ( 111, 170, 102 ),   ( 112, 170, 101 ),   ( 113, 169, 100 ),   ( 114, 169, 99 ),
      ( 115, 169, 98 ),   ( 116, 169, 98 ),   ( 117, 169, 97 ),   ( 118, 168, 96 ),
      ( 119, 168, 95 ),   ( 120, 168, 95 ),   ( 121, 167, 94 ),   ( 122, 167, 93 ),
      ( 123, 166, 93 ),   ( 124, 166, 92 ),   ( 125, 165, 92 )
    );

    type position_array is array (0 to 2) of integer range 0 to step_count - 1; 
    type rom_array  is array (0 to 2) of unsigned(step_bits - 1 downto 0);

    function int_equal(expected: integer; actual: integer) 
    return integer is
        variable equal : integer;
    begin
        equal := abs(expected - actual);
        if (equal = 0) then
            return 1;
        else
            if (equal <= 2) then 
                return 1;
            else
                return 0;
            end if;
        end if;
        return 0;
    end function;

    function unsigned_equal(expected: unsigned(step_bits - 1 downto 0); actual: unsigned(step_bits - 1 downto 0)) 
    return integer is
        variable equal : unsigned(step_bits - 1 downto 0);
    begin
        equal := expected - actual;
        if expected > actual then
            equal := expected - actual;
        else
            equal := actual - expected;
        end if;
    if (equal = "00000000") then
            return 1;
        else
            if (equal <= "10") then 
                return 1;
            else
                return 0;
            end if;
        end if;
        -- return 0;
    end function;

    procedure compare_position(stimulus : stimulus_data; value : position_array) is
    begin
        assert  int_equal(stimulus(0), value(0)) = 1 and 
                int_equal(stimulus(1), value(1)) = 1 and
                int_equal(stimulus(2), value(2)) = 1
          report "Stimulus position failed" & LF &
            "Expected (" & integer'image(stimulus(0)) & "," 
                         & integer'image(stimulus(1)) & ","
                         & integer'image(stimulus(2)) & ")" & LF &
            "Actual   (" & integer'image(value(0)) & "," 
                         & integer'image(value(1)) & ","
                         & integer'image(value(2)) & ")"
          severity error;
        
    end procedure;

    procedure compare_angle(stimulus : stimulus_data; value : rom_array) is
    begin
        assert unsigned_equal(to_unsigned(stimulus(0), step_bits), value(0)) = 1 and 
               unsigned_equal(to_unsigned(stimulus(1), step_bits), value(1)) = 1 and
               unsigned_equal(to_unsigned(stimulus(2), step_bits), value(2)) = 1 
        report "Stimulus angle failed" & LF &
            "Expected (" & integer'image(stimulus(0)) & "," 
                         & integer'image(stimulus(1)) & ","
                         & integer'image(stimulus(2)) & ")" & LF &
            "Actual   (" & integer'image(to_integer(value(0))) & "," 
                         & integer'image(to_integer(value(1))) & ","
                         & integer'image(to_integer(value(2))) & ")"
          
            severity error;
        
    end procedure;

    procedure compare_sin(stimulus : stimulus_data; value : rom_array) is
        begin
        assert unsigned_equal(to_unsigned(stimulus(0), step_bits), value(0)) = 1 and 
               unsigned_equal(to_unsigned(stimulus(1), step_bits), value(1)) = 1 and
               unsigned_equal(to_unsigned(stimulus(2), step_bits), value(2)) = 1 
        report "Stimulus sin failed" & LF &
                "Expected (" & integer'image(stimulus(0)) & "," 
                             & integer'image(stimulus(1)) & ","
                             & integer'image(stimulus(2)) & ")" & LF &
                "Actual   (" & integer'image(to_integer(value(0))) & "," 
                             & integer'image(to_integer(value(1))) & ","
                             & integer'image(to_integer(value(2))) & ")"
              
                severity error;
            
        end procedure;
    
    begin

    clk <= not clk after clk_period / 2;

    DUT : entity work.circle_stage(rtl)
    generic map (
        step_bits => step_bits,
        cnt_bits => cnt_bits
    )
    port map (
        clk => clk,
        rst_n => rst_n,
        pwm => pwm
    );

    SEQUENCER_PROC : process
--        variable step_time : time := 2*128*128*256 * clk_period;
        variable step_time : time := (4*128*256-128) * clk_period;
        variable steps : integer := 255;
        alias position is <<signal .circle_stage_tb.DUT.position : position_array>>;
        alias angle is <<signal .circle_stage_tb.DUT.angle : rom_array>>;
        alias sin is <<signal .circle_stage_tb.DUT.sin : rom_array>>;
    begin
  
        wait for clk_period * 2;

        report "Verifying rst_n = '1'";
        rst_n <= '0';
        wait for clk_period * 10;

        report "Verifying rst_n = '0'";
        rst_n <= '1';
        wait for clk_period * 10;

        for step in 1 to steps loop
            report "Verifying pwm position at (" & integer'image(step) & "/" & integer'image(steps) & ")";
            wait for step_time;

            compare_angle(test_angle(step), angle);
            -- compare_sin(test_sin(step), sin);
            compare_position(test_position(step), position);

        end loop;

        wait for clk_period * 4;

        report "Test successful.";

        finish;
    end process;

end architecture;