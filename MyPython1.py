'''
MyPython1.py

Entry to Python/GAMS benchmark solver, timed portion.
Syntax:

$ python MyPython1.py CON INL RAW ROP
'''

# built in imports
import os, sys, shutil

# need to install
import gams

# GOComp modules - this should be visible on the GOComp evaluation system
import psse

# Python/GAMS benchmark modules
sys.path.append(os.path.normpath('src/python')) # better way to make this visible?
import gams_utils
    
def main():
    
    args = sys.argv

    con_name = args[1]
    inl_name = args[2]
    raw_name = args[3]
    rop_name = args[4]
    sol1_name = 'solution1.txt'
    sol2_name = 'solution2.txt'
    gdx_name = 'pscopf.gdx'
    gms_name = 'run_greedy.gms'
    gams_work_dir = 'src/gams/'

    print '\nPython/GAMS benchmark solver'
    print 'MyPython1.py'
    
    # read the psse files
    print 'reading psse files'
    p = psse.Psse()
    print 'reading raw file: %s' % raw_name
    if raw_name is not None:
        p.raw.read(os.path.normpath(raw_name))
    print 'reading rop file: %s' % rop_name
    if rop_name is not None:
        p.rop.read(os.path.normpath(rop_name))
    print 'reading inl file: %s' % inl_name
    if inl_name is not None:
        p.inl.read(os.path.normpath(inl_name))
    print 'reading con file: %s' % con_name
    if con_name is not None:
        p.con.read(os.path.normpath(con_name))
    print "buses: %u" % len(p.raw.buses)
    print "loads: %u" % len(p.raw.loads)
    print "fixed_shunts: %u" % len(p.raw.fixed_shunts)
    print "generators: %u" % len(p.raw.generators)
    print "nontransformer_branches: %u" % len(p.raw.nontransformer_branches)
    print "transformers: %u" % len(p.raw.transformers)
    #print "areas: %u" % len(p.raw.areas)
    print "switched_shunts: %u" % len(p.raw.switched_shunts)
    print "generator inl records: %u" % len(p.inl.generator_inl_records)
    print "generator dispatch records: %u" % len(p.rop.generator_dispatch_records)
    print "active power dispatch records: %u" % len(p.rop.active_power_dispatch_records)
    print "piecewise linear cost functions: %u" % len(p.rop.piecewise_linear_cost_functions)
    print 'contingencies: %u' % len(p.con.contingencies)

    # write to gdx
    print 'writing gdx input file: %s' % gdx_name
    gams_utils.write_psse_to_gdx(p, os.path.normpath(gams_work_dir + gdx_name))

    # test gams
    print 'running gams model: %s' % gms_name
    ws = gams.GamsWorkspace()
    ws.__init__(working_directory=(os.path.normpath(gams_work_dir)))
    job = ws.add_job_from_file(os.path.normpath(gms_name))
    opt = gams.GamsOptions(ws)
    opt.defines['ingdx'] = os.path.normpath(gdx_name)
    opt.defines['solution1'] = os.path.normpath('../../' + sol1_name)
    opt.defines['solution2'] = os.path.normpath('../../' + sol2_name)
    job.run(gams_options=opt, output=sys.stdout)

    # gams model writes the solution files
    # might be better to return GAMS solution data to Python and have Python write the solution files

if __name__ == '__main__':
    main()
