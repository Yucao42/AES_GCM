
a = open('text_bypasser.sv', 'a')

declarer = ['    logic [0: 127]        bypass{}\n'.format(i) for i in range(10)]
mods = ['''
    aes_signal_passing pass{}
    (
        .clk(clk),
        .i_plain_text(bypass{}),
        .o_plain_text(bypass{})
    )
        '''.format(i, i, i + 1) for i in range(15)]
with open('text_bypasser.sv', 'a') as f:
    for m in mods:
        f.write(m)
