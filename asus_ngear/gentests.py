#!/usr/bin/env python2

def gen_2():
    ch = '1'
    ants = ['1x1', '2x2']
    bws = ['20', '40']
    ttypes = ['tcp', 'udp']
    vhts = ['n']

    for ant in ants:
        for bw in bws:
            for vht in vhts:
                for ttype in ttypes:
                    print """
run_test_2      $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKA
run_test_2      $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKB
run_test_2      $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKC

run_test_dual_2 $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKA $SINKB
run_test_dual_2 $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKA $SINKC
run_test_dual_2 $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKB $SINKC

run_test_trip_5 $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKA $SINKB $SINKC
""".format(ch=ch,bw=bw,ant=ant,ttype=ttype,vht=vht)

def gen_5():
    ch = '48'
    ants = ['1x1', '2x2', '3x3']
    bws = ['20', '40', '80']
    ttypes = ['tcp', 'udp']
    vhts = ['ac', 'n']

    for ant in ants:
        for bw in bws:
            for vht in vhts:
                for ttype in ttypes:
                    print """
run_test_5      $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKA
run_test_5      $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKB
run_test_5      $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKC

run_test_dual_5 $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKA $SINKB
run_test_dual_5 $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKA $SINKC
run_test_dual_5 $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKB $SINKC

run_test_trip_5 $DUTA {ch} {bw} {ant} {ttype} {vht} $SINKA $SINKB $SINKC
""".format(ch=ch,bw=bw,ant=ant,ttype=ttype,vht=vht)

def main():
    gen_2()
    gen_5()

if __name__ == '__main__':
    main()




