
a = open('text_bypasser.sv', 'a')

declarer = ['    logic [0: 127]        bypass{}\n'.format(i) for i in range(10)]
mods = ['''
    aes_signal_passing pass{}
    (
        .clk(clk),
        .i_plain_text(bytext{}),
        .i_aad(byaad{}),
        .i_signal(bysig{}),
        .i_instance_size(byins{}),
        .o_instance_size(byins{}),
        .o_aad(byaad{}),
        .o_signal(bysig{}),
        .o_plain_text(bypass{})
    )
        '''.format(i, i, i, i, i, i + 1,  i + 1, i + 1,  i + 1) for i in range(15)]
with open('bypasser.sv', 'a') as f:
    for m in mods:
        f.write(m)
