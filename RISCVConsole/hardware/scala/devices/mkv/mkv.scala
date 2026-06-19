package riscvconsole.devices.mkv

import chisel3._
import chisel3.util._
import freechips.rocketchip.config.{Field, Parameters}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.diplomaticobjectmodel.model.OMRegister
import freechips.rocketchip.regmapper._
import freechips.rocketchip.subsystem.{Attachable, BaseSubsystem, PBUS, TLBusWrapperLocation}
import freechips.rocketchip.tilelink._

class MKV_CRYPTO_TOP extends BlackBox with HasBlackBoxResource {
  val io = IO(new Bundle {
    val clk   = Input(Clock())
    val rst   = Input(Bool())   // active-high

    val start = Input(Bool())
    val key_master  = Input(UInt(256.W))
    val done_key_debug = Output(Bool())

    val sel_crypt = Input(Bool())
    val data_in = Input(UInt(128.W))

    val done = Output(Bool())
    val data_out   = Output(UInt(128.W))
  })
  addResource("/MKV/MKV_CRYPTO_TOP.vhd")
  addResource("/MKV/encrypt.vhd")
  addResource("/MKV/decrypt.vhd")
  addResource("/MKV/Key_Expansion.vhd")
  addResource("/MKV/Gen_Key.vhd")
  addResource("/MKV/INV_N_ROUND.vhd")
  addResource("/MKV/N_ROUND.vhd")
  addResource("/MKV/inv_Subcells_128.vhd")
  addResource("/MKV/Subcells_128.vhd")
  addResource("/MKV/invMixWords.vhd")
  addResource("/MKV/MixWords.vhd")
  addResource("/MKV/invSubCells.vhd")
  addResource("/MKV/SubCells.vhd")
  addResource("/MKV/XWords.vhd")
}
case class MKVParams(address: BigInt)

object MKVCtrlRegs {
  val trigger   = 0x00 //rst
  val status    = 0x04 //done_key_debug, done
  val start     = 0x08 //start, sel_crypt
  val data_in   = 0x10
  val key_in    = 0x20
  val data_out  = 0x40
}

abstract class MKVmod(busBytes: Int, val c: MKVParams)(implicit p: Parameters)
  extends RegisterRouter(
    RegisterRouterParams(
      name      = "mkv",
      compat    = Seq("console,MKV0"),
      base      = c.address,
      beatBytes = busBytes
    ),
  ){
  lazy val module = new LazyModuleImp(this) {
    val mod = Module(new MKV_CRYPTO_TOP)
    //declare inputs
    val key_in0 = RegInit(0.U(32.W))
    val key_in1 = RegInit(0.U(32.W))
    val key_in2 = RegInit(0.U(32.W))
    val key_in3 = RegInit(0.U(32.W))
    val key_in4 = RegInit(0.U(32.W))
    val key_in5 = RegInit(0.U(32.W))
    val key_in6 = RegInit(0.U(32.W))
    val key_in7 = RegInit(0.U(32.W))

    val data_in0 = RegInit(0.U(32.W))
    val data_in1 = RegInit(0.U(32.W))
    val data_in2 = RegInit(0.U(32.W))
    val data_in3 = RegInit(0.U(32.W))

    val key_inCat   = Cat(key_in7, key_in6, key_in5, key_in4,
                          key_in3, key_in2, key_in1, key_in0)
    val data_inCat  = Cat(data_in3, data_in2, data_in1, data_in0)

    val rst       = RegInit(false.B)
    val trig1     = RegInit(false.B)
    val trig2     = RegInit(false.B)
    //mapping inputs
    mod.io.clk     := clock
    mod.io.rst     := reset.asBool || rst
    mod.io.start   := trig1
    mod.io.key_master  := key_inCat
    mod.io.sel_crypt  := trig2
    mod.io.data_in := data_inCat
    //declare outputs
    val done_o = Wire(Bool())
    val done_key_o = Wire(Bool())
    //mapping outputs
    done_o      := mod.io.done
    done_key_o      := mod.io.done_key_debug
    val data_out0 = mod.io.data_out(31, 0)
    val data_out1 = mod.io.data_out(63, 32)
    val data_out2 = mod.io.data_out(95, 64)
    val data_out3 = mod.io.data_out(127, 96)

    // map to register
    val mapping = Seq(
      MKVCtrlRegs.trigger -> Seq(
        RegField(1, rst, RegFieldDesc("rst","MKV_resetat1",reset = Some(0)))
      ),
      MKVCtrlRegs.status  -> Seq(
        RegField.r(1, done_o,
          RegFieldDesc("check_output", "done_crypt", volatile = true)
        ),
        RegField.r(1, done_key_o,
          RegFieldDesc("check_done_key", "done_key", volatile = true)
        )
      ),
      MKVCtrlRegs.start -> Seq(
        RegField(1, trig1,
          RegFieldDesc("start_key_expansion", "start_key")
        ),
        RegField(1, trig2,
          RegFieldDesc("select_crypto_mode", "encrypt_or_decrypt")
        )
      ),
      MKVCtrlRegs.data_in -> Seq(
        RegField(32, data_in0),
        RegField(32, data_in1),
        RegField(32, data_in2),
        RegField(32, data_in3)
      ),
      MKVCtrlRegs.key_in -> Seq(
        RegField(32, key_in0),
        RegField(32, key_in1),
        RegField(32, key_in2),
        RegField(32, key_in3),
        RegField(32, key_in4),
        RegField(32, key_in5),
        RegField(32, key_in6),
        RegField(32, key_in7)
      ),
      MKVCtrlRegs.data_out -> Seq(

        RegField.r(32, data_out0),
        RegField.r(32, data_out1),
        RegField.r(32, data_out2),
        RegField.r(32, data_out3)
      )
    )
    regmap(mapping : _*)
    val omRegMap = OMRegister.convert(mapping:_*)
  }
}

class TLMKV(busBytes: Int, params: MKVParams)(implicit p: Parameters)
  extends MKVmod(busBytes, params) with HasTLControlRegMap

case class MKVAttachParams
(
   device: MKVParams,
   controlWhere: TLBusWrapperLocation = PBUS)
{
  def attachTo(where: Attachable)(implicit p: Parameters): TLMKV = where {
    val cbus  = where.locateTLBusWrapper(controlWhere)
    val MKV   = LazyModule(new TLMKV(cbus.beatBytes, device))
    MKV.suggestName("mkv")

    cbus.coupleTo("mkv_slave") { bus =>
      (MKV.controlXing(NoCrossing)
        := TLFragmenter(cbus)
        := bus )
    }
    MKV
  }
}
case object PeripheryMKVKey
  extends Field[Seq[MKVAttachParams]](Nil)
trait HasPeripheryMKV { this: BaseSubsystem =>
  val MKVNodes = p(PeripheryMKVKey).map {
    ps => ps.attachTo(this)
  }
}
