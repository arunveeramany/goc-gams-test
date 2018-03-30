# utilities for generating gams data, running a gams model, and getting
# the solution
# uses the GAMS Python API.

import gams, os, math

def write_psse_to_gdx(psse_data, filename):

    # set up gams env and db
    ws = gams.GamsWorkspace()
    ws.__init__(working_directory=os.getcwd())
    db = ws.add_database()
    
    # write to db
    write_psse_to_gdx_db(psse_data, db)
    
    # export to gdx
    db.export(filename)

def write_psse_to_gdx_db(psse_data, db):
    '''Write to a Gams database.'''
    
    # declarations
    
    # sets
    num = db.add_set('Num', 1)
    ident = db.add_set('Ident', 1)
    name = db.add_set('Name', 1)
    bus = db.add_set('Bus', 1)
    load = db.add_set('Load', 2)
    fxsh = db.add_set('Fxsh', 2)
    gen = db.add_set('Gen', 2)
    line = db.add_set('Line', 3)
    xfmr = db.add_set('Xfmr', 3)
    area = db.add_set('Area', 1) # todo
    swsh = db.add_set('Swsh', 1)
    #swsh_blk = db.add_set('SwshBlk', 2) # todo
    load_active = db.add_parameter('LoadActive', 2)
    fxsh_active = db.add_parameter('FxshActive', 2)
    gen_active = db.add_parameter('GenActive', 2)
    line_active = db.add_parameter('LineActive', 3)
    xfmr_active = db.add_parameter('XfmrActive', 3)
    swsh_active = db.add_parameter('SwshActive', 1)
    gen_pl = db.add_set('GenPl', 3)
    ctg = db.add_set('Ctg', 1)
    gen_bus_v_reg = db.add_set('GenBusVReg', 3)
    #swsh_bus_v_reg = db.add_set('SwshBusVReg', 2)
    #bus_area = db.add_set('BusArea', 2)
    gen_area = db.add_set('GenArea', 3)
    gen_ctg_inactive = db.add_set('GenCtgInactive', 3)
    line_ctg_inactive = db.add_set('LineCtgInactive', 4)
    xfmr_ctg_inactive = db.add_set('XfmrCtgInactive', 4)
    area_ctg_affected = db.add_set('AreaCtgAffected', 2)
    
    # case identification parameters
    base_mva = db.add_parameter('BaseMVA', 0)
    
    # bus parameters
    bus_base_kv = db.add_parameter('BusBaseKV', 1)
    #bus_ide = db.add_parameter('bus_ide', 1)
    #bus_area = db.add_parameter('bus_area', 1)
    #bus_area = db.add_parameter('bus_area', 1)
    #bus_owner = db.add_parameter('bus_owner', 1)
    #bus_vm = db.add_parameter('bus_vm', 1)
    #bus_va = db.add_parameter('bus_va', 1)
    bus_v_max = db.add_parameter('BusVMax', 1)
    bus_v_min = db.add_parameter('BusVMin', 1)
    #bus_evhi = db.add_parameter('bus_evhi', 1)
    #bus_evlo = db.add_parameter('bus_evlo', 1)
    
    # load parameters
    #load_status = db.add_parameter('load_status', 2)
    #load_area = db.add_parameter('load_area', 2)
    #load_area = db.add_parameter('load_area', 2)
    load_p = db.add_parameter('LoadP', 2)
    load_q = db.add_parameter('LoadQ', 2)
    #load_ip = db.add_parameter('load_ip', 2)
    #load_iq = db.add_parameter('load_iq', 2)
    #load_yp = db.add_parameter('load_yp', 2)
    #load_yq = db.add_parameter('load_yq', 2)
    
    # fixed shunt parameters
    #fxsh_status = db.add_parameter('fxsh_status', 2)
    fxsh_g = db.add_parameter('FxshG', 2)
    fxsh_b = db.add_parameter('FxshB', 2)
    
    # generator parameters
    #gen_pg = db.add_parameter('gen_pq', 2)
    #gen_qg = db.add_parameter('gen_qg', 2)
    gen_q_max = db.add_parameter('GenQMax', 2)
    gen_q_min = db.add_parameter('GenQMin', 2)
    #gen_vs = db.add_parameter('gen_vs', 2)
    #gen_ireg = db.add_parameter('gen_ireg', 2)
    #gen_mbase = db.add_parameter('gen_mbase', 2)
    #gen_zr = db.add_parameter('gen_zr', 2)
    #gen_zx = db.add_parameter('gen_zx', 2)
    #gen_rt = db.add_parameter('gen_rt', 2)
    #gen_xt = db.add_parameter('gen_xt', 2)
    #gen_gtap = db.add_parameter('gen_gtap', 2)
    #gen_rmpct = db.add_parameter('gen_rmpct', 2)
    gen_p_max = db.add_parameter('GenPMax', 2)
    gen_p_min = db.add_parameter('GenPMin', 2)
    #gen_o1 = db.add_parameter('gen_o1', 2)
    #gen_f1 = db.add_parameter('gen_f1', 2)
    #gen_o2 = db.add_parameter('gen_o2', 2)
    #gen_f2 = db.add_parameter('gen_f2', 2)
    #gen_o3 = db.add_parameter('gen_o3', 2)
    #gen_f3 = db.add_parameter('gen_f3', 2)
    #gen_o4 = db.add_parameter('gen_o4', 2)
    #gen_f4 = db.add_parameter('gen_f4', 2)
    #gen_wmod = db.add_parameter('gen_wmod', 2)
    #gen_wpf = db.add_parameter('gen_wpf', 2)
    
    # line parameters
    #line_r = db.add_parameter('LineR', 3)
    #line_x = db.add_parameter('LineX', 3)
    line_g = db.add_parameter('LineG', 3)
    line_b = db.add_parameter('LineB', 3)
    line_b_ch = db.add_parameter('LineBCh', 3)
    line_flow_max = db.add_parameter('LineFlowMax', 3)
    #line_rateb = db.add_parameter('line_rateb', 3)
    #line_ratec = db.add_parameter('line_ratec', 3)
    #line_gi = db.add_parameter('line_gi', 3)
    #line_bi = db.add_parameter('line_bi', 3)
    #line_gj = db.add_parameter('line_gj', 3)
    #line_bj = db.add_parameter('line_bj', 3)
    #line_st = db.add_parameter('line_st', 3)
    
    # transformer parameters
    xfmr_g_mag = db.add_parameter('XfmrGMag', 3)
    xfmr_b_mag = db.add_parameter('XfmrBMag', 3)
    #xfmr_stat = db.add_parameter('xfmr_', 3)
    xfmr_g = db.add_parameter('XfmrG', 3)
    xfmr_b = db.add_parameter('XfmrB', 3)
    xfmr_ratio = db.add_parameter('XfmrRatio', 3)
    xfmr_ang = db.add_parameter('XfmrAng', 3)
    xfmr_flow_max = db.add_parameter('XfmrFlowMax', 3)
    
    # switched shunt parameters
    #swsh_modsw = db.add_parameter('swsh_modsw', 1)
    #swsh_adjm = db.add_parameter('swsh_adjm', 1)
    #swsh_stat = db.add_parameter('swsh_stat', 1)
    #swsh_v_hi = db.add_parameter('SwshVHi', 1)
    #swsh_v_lo = db.add_parameter('SwshVLo', 1)
    #swsh_swrem = db.add_parameter('swsh_swrem', 1)
    #swsh_rmpct = db.add_parameter('swsh_rmpct', 1)
    #swsh_rmidnt = db.add_parameter('swsh_rmidnt', 1)
    #swsh_b_init = db.add_parameter('SwshBInit', 1)
    swsh_b_max = db.add_parameter('SwshBMax', 1)
    swsh_b_min = db.add_parameter('SwshBMin', 1)
    #swsh_n1 = db.add_parameter('swsh_n1', 1)
    #swsh_b1 = db.add_parameter('swsh_b1', 1)
    #swsh_n2 = db.add_parameter('swsh_n2', 1)
    #swsh_b2 = db.add_parameter('swsh_b2', 1)
    #swsh_n3 = db.add_parameter('swsh_n3', 1)
    #swsh_b3 = db.add_parameter('swsh_b3', 1)
    #swsh_n4 = db.add_parameter('swsh_n4', 1)
    #swsh_b4 = db.add_parameter('swsh_b4', 1)
    #swsh_n5 = db.add_parameter('swsh_n5', 1)
    #swsh_b5 = db.add_parameter('swsh_b5', 1)
    #swsh_n6 = db.add_parameter('swsh_n6', 1)
    #swsh_b6 = db.add_parameter('swsh_b6', 1)
    #swsh_n7 = db.add_parameter('swsh_n7', 1)
    #swsh_b7 = db.add_parameter('swsh_b7', 1)
    #swsh_n8 = db.add_parameter('swsh_n8', 1)
    #swsh_b8 = db.add_parameter('swsh_b8', 1)
    
    # TODO - might or might not need this
    gen_part_fact = db.add_parameter('GenPartFact', 2)
    
    # piecewise linear cost function parameters
    gen_pl_x = db.add_parameter('GenPlX', 3)
    gen_pl_y = db.add_parameter('GenPlY', 3)
    
    # records
    
    # nums
    max_num = max(
        [r.i for r in psse_data.raw.buses.values()] +
        [r.area for r in psse_data.raw.buses.values()] +
        [r.npairs for r in psse_data.rop.piecewise_linear_cost_functions.values()]
    )
    # might need more from other tables
    unique_nums = [str(i) for i in range(1, max_num + 1)]
    for i in unique_nums:
        num.add_record(i)
    
    # idents
    unique_idents = list(set(
        [r.id for r in psse_data.raw.loads.values()] +
        [r.id for r in psse_data.raw.fixed_shunts.values()] +
        [r.id for r in psse_data.raw.generators.values()] +
        [r.ckt for r in psse_data.raw.nontransformer_branches.values()] +
        [r.ckt for r in psse_data.raw.transformers.values()]))
    for i in unique_idents:
        ident.add_record(i)
        
    # names - just those from contingency labels
    unique_names = list(set(
        [r.label for r in psse_data.con.contingencies.values()]))
    for i in unique_names:
        name.add_record(i)
        
    # case identification records
    base_mva.add_record().value = psse_data.raw.case_identification.sbase
    
    # bus records
    for r in psse_data.raw.buses.values():
        key = str(r.i)
        bus.add_record(key)
        #bus_name.add_record(key).value = r.name
        bus_base_kv.add_record(key).value = r.baskv
        #bus_ide.add_record(key).value = r.ide
        #bus_area.add_record(key).value = r.area
        #bus_owner.add_record(key).value = r.owner
        #bus_vm.add_record(key).value = r.vm
        #bus_va.add_record(key).value = r.va
        bus_v_max.add_record(key).value = r.nvhi
        bus_v_min.add_record(key).value = r.nvlo
        #bus_evhi.add_record(key).value = r.evhi
        #bus_evlo.add_record(key).value = r.evlo
        
    # load records
    for r in psse_data.raw.loads.values():
        key = (str(r.i), str(r.id))
        load.add_record(key)
        if r.status > 0:
            load_active.add_record(key)
        #load_area.add_record(key).value = r.
        #load_area.add_record(key).value = r.
        load_p.add_record(key).value = r.pl / psse_data.raw.case_identification.sbase
        load_q.add_record(key).value = r.ql / psse_data.raw.case_identification.sbase
        #load_ip.add_record(key).value = r.
        #load_iq.add_record(key).value = r.
        #load_yp.add_record(key).value = r.
        #load_yq.add_record(key).value = r.
        
    # fixed shunt records
    for r in psse_data.raw.fixed_shunts.values():
        key = (str(r.i), str(r.id))
        fxsh.add_record(key)
        if r.status > 0:
            fxsh_active.add_record(key)
        fxsh_g.add_record(key).value = r.gl / psse_data.raw.case_identification.sbase
        fxsh_b.add_record(key).value = r.bl / psse_data.raw.case_identification.sbase
    
    # generator records
    for r in psse_data.raw.generators.values():
        key = (str(r.i), str(r.id))
        gen.add_record(key)
        if r.stat > 0:
            gen_active.add_record(key).value
        #gen_pg.add_record(key).value = r.pg
        #gen_qg.add_record(key).value = r.qg
        gen_q_max.add_record(key).value = r.qt / psse_data.raw.case_identification.sbase
        gen_q_min.add_record(key).value = r.qb / psse_data.raw.case_identification.sbase
        #gen_vs.add_record(key).value = r.vs
        if r.ireg == 0: # should process the default here - and document the default value - wait no we do not allow defaults
            gen_bus_v_reg.add_record((str(r.i), str(r.id), str(r.i)))
        else:
            gen_bus_v_reg.add_record((str(r.i), str(r.id), str(r.ireg)))
        #gen_mbase.add_record(key).value = r.mbase
        #gen_zr.add_record(key).value = r.zr
        #gen_zx.add_record(key).value = r.zx
        #gen_rt.add_record(key).value = r.rt
        #gen_xt.add_record(key).value = r.xt
        #gen_gtap.add_record(key).value = r.gtap
        #gen_stat.add_record(key).value = r.stat
        #gen_rmpct.add_record(key).value = r.rmpct
        gen_p_max.add_record(key).value = r.pt / psse_data.raw.case_identification.sbase
        gen_p_min.add_record(key).value = r.pb / psse_data.raw.case_identification.sbase
        gen_area.add_record((str(r.i), str(r.id), str(psse_data.raw.buses[r.i].area)))
        
    # line records
    for r in psse_data.raw.nontransformer_branches.values():
        key = (str(r.i), str(r.j), str(r.ckt))
        line.add_record(key)
        if r.st > 0:
            line_active.add_record(key)
        line_g.add_record(key).value = r.r / (r.r**2.0 + r.x**2.0)
        line_b.add_record(key).value = -r.x / (r.r**2.0 + r.x**2.0)
        line_b_ch.add_record(key).value = r.b
        line_flow_max.add_record(key).value = r.ratea / psse_data.raw.case_identification.sbase # todo - normalize - see below
        #line_flow_max.add_record(key).value = r.ratea / psse_data.raw.bus_dict[r.i].basekv # todo - normalize - need to define this dict
        #line_rateb.add_record(key).value = r.
        #line_ratec.add_record(key).value = r.
        #line_gi.add_record(key).value = r.
        #line_bi.add_record(key).value = r.
        #line_gj.add_record(key).value = r.
        #line_bj.add_record(key).value = r.
        #line_st.add_record(key).value = r.
        
    # transformer records
    for r in psse_data.raw.transformers.values():
        key = (str(r.i), str(r.j), str(r.ckt))
        xfmr.add_record(key)
        if r.stat > 0:
            xfmr_active.add_record(key)
        xfmr_g_mag.add_record(key).value = r.mag1 # todo normalize?
        xfmr_b_mag.add_record(key).value = r.mag2 # todo normalize?
        #xfmr_stat.add_record(key).value = r.
        xfmr_g.add_record(key).value = r.r12 / (r.r12**2.0 + r.x12**2.0)
        xfmr_b.add_record(key).value = -r.x12 / (r.r12**2.0 + r.x12**2.0)
        xfmr_ratio.add_record(key).value = r.windv1 / r.windv2
        xfmr_ang.add_record(key).value = r.ang1 * math.pi / 180.0
        xfmr_flow_max.add_record(key).value = r.rata1 / psse_data.raw.case_identification.sbase # todo normalize
    
    # area records - no area object for now - get this from bus records
    #for r in psse_data.raw.areas.values():
    #    key = str(r.i)
    #    area.add_record(key)
    area_temp = sorted(set([r.area for r in psse_data.raw.buses.values()]))
    for i in area_temp:
        area.add_record(str(i))
    
    # switched shunt records
    for r in psse_data.raw.switched_shunts.values():
        key = str(r.i)
        swsh.add_record(key)
        if r.stat > 0:
            swsh_active.add_record(key)
        #swsh_modsw.add_record(key).value = r.modsw
        #swsh_adjm.add_record(key).value = r.adjm
        #swsh_stat.add_record(key).value = r.stat
        #swsh_v_hi.add_record(key).value = r.vswhi
        #swsh_v_lo.add_record(key).value = r.vswlo
        #if r.swrem == 0: # should process the default here - and document the default value - wait no we do not allow defaults
        #    swsh_bus_v_reg.add_record((str(r.i), str(r.i)))
        #else:
        #    swsh_bus_v_reg.add_record((str(r.i), str(r.swrem)))
        #swsh_b_init.add_record(key).value = r.binit / psse_data.raw.case_identification.sbase # todo normalize ?
        swsh_b_max.add_record(key).value = (
            max(0.0, r.n1 * r.b1) +
            max(0.0, r.n2 * r.b2) +
            max(0.0, r.n3 * r.b3) +
            max(0.0, r.n4 * r.b4) +
            max(0.0, r.n5 * r.b5) +
            max(0.0, r.n6 * r.b6) +
            max(0.0, r.n7 * r.b7) +
            max(0.0, r.n8 * r.b8)) / psse_data.raw.case_identification.sbase # todo normalize ?
        swsh_b_min.add_record(key).value = (
            min(0.0, r.n1 * r.b1) +
            min(0.0, r.n2 * r.b2) +
            min(0.0, r.n3 * r.b3) +
            min(0.0, r.n4 * r.b4) +
            min(0.0, r.n5 * r.b5) +
            min(0.0, r.n6 * r.b6) +
            min(0.0, r.n7 * r.b7) +
            min(0.0, r.n8 * r.b8)) / psse_data.raw.case_identification.sbase # todo normalize ?
    
    # generator inl records
    for r in psse_data.inl.generator_inl_records.values():
        key = (str(r.i), str(r.id))
        gen_part_fact.add_record(key).value = r.r
    
    # piecewise linear cost functions
    for r in psse_data.rop.generator_dispatch_records.values():
        r_bus = r.bus
        r_genid = r.genid
        r_dsptbl = r.dsptbl
        s = psse_data.rop.active_power_dispatch_records[r_dsptbl]
        r_ctbl = s.ctbl
        t = psse_data.rop.piecewise_linear_cost_functions[r_ctbl]
        r_npairs = t.npairs
        for i in range(r_npairs):
            key = (str(r_bus), str(r_genid), str(i + 1))
            gen_pl.add_record(key)
            gen_pl_x.add_record(key).value = t.points[i].x / psse_data.raw.case_identification.sbase
            gen_pl_y.add_record(key).value = t.points[i].y            
    
    # contingency records
    # TODO - stll need gen_ctg_part_fact
    # and area_ctg_affected will need to be done more carefully
    area_ctg_affected_temp = set()
    for r in psse_data.con.contingencies.values():
        key = str(r.label)
        ctg.add_record(key)
        for e in r.branch_out_events:
            ekey = (str(e.i), str(e.j), str(e.ckt), key)
            area_ctg_affected_temp.add((str(psse_data.raw.buses[e.i].area), key))
            area_ctg_affected_temp.add((str(psse_data.raw.buses[e.j].area), key))
            if (e.i, e.j, e.ckt) in psse_data.raw.nontransformer_branches.keys():
                line_ctg_inactive.add_record(ekey)
            if (e.i, e.j, 0, e.ckt) in psse_data.raw.transformers.keys():
                xfmr_ctg_inactive.add_record(ekey)
        for e in r.generator_out_events:
            ekey = (str(e.i), str(e.id), key)
            area_ctg_affected_temp.add((str(psse_data.raw.buses[e.i].area), key))
            gen_ctg_inactive.add_record(ekey)
    for k in area_ctg_affected_temp:
        area_ctg_affected.add_record(k)
