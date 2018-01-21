`define RUN_COUNT 10
class xname extends dma_transaction;
  constraint tr_mode_constraint {
    tr_mode == XMODE;
  }

  constraint size_trans_constraint {
    size_trans == XSIZE;
  }

  constraint reload_constraint {
		re_load  == XR;
  }

  constraint addr_mode_constraint {
    addr_mode == XAD;
  }
endclass

program dma_test ( dma_interface dma_if);
  dma_environment env;
  xname tr_os; 

  initial begin
    env = new(dma_if);
    env.build();

    begin : config_gen
			tr_os = new();
			env.gen.run_count = `RUN_COUNT;
			env.drv.run_count = `RUN_COUNT;
			env.gen.blueprint = tr_os;
    end : config_gen

    env.run();
  end
endprogram
