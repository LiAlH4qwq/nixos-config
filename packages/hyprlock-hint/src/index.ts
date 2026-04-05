import { Command, Options } from "@effect/cli"
import { BunContext, BunRuntime } from "@effect/platform-bun"
import { Console, Effect, pipe } from "effect"

const cmd_op_user = Options.text("user").pipe(
    Options.withDescription("$USER, current user's username."),
    Options.withDefault("user")
)

const cmd_op_user_desc = Options.text("user-desc").pipe(
    Options.withDescription("$Desc, current user's description."),
    Options.withDefault("User")
)

const cmd_op_time = Options.text("time").pipe(
    Options.withDescription(`$TIME, current time in format like "19:35".`),
    Options.withDefault("19:35")
)

const cmd_op_time_12 = Options.text("time-12").pipe(
    Options.withDescription(`$TIME12, current time in format like "7:35 PM".`),
    Options.withDefault("7:35 PM")
)

const cmd_op_kb_layout = Options.text("kb-layout").pipe(
    Options.withDescription("$LAYOUT, current keyboard layout."),
    Options.withDefault("us")
)

const cmd_op_auth_fail_num = Options.integer("auth-fail-num").pipe(
    Options.withDescription("$ATTEMPTS, current auth fail counts."),
    Options.withDefault(0)
)

const cmd_op_auth_fail_msg = Options.text("auth-fail-msg").pipe(
    Options.withDescription("$FAIL, last auth fail reason."),
    Options.withDefault("Unknown error!")
)

const cmd_op_auth_pam_prompt_msg = Options.text("auth-pam-prompt-msg").pipe(
    Options.withDescription("$PAMPROMPT, current pam auth prompt."),
    Options.withDefault("Please auth:")
)

const cmd_op_auth_pam_fail_msg = Options.text("auth-pam-fail-msg").pipe(
    Options.withDescription("$PAMFAIL, last pam auth fail reason."),
    Options.withDefault("Unknown error!")
)

const cmd_op_auth_fprint_prompt_msg = Options.text("auth-fprint-prompt-msg").pipe(
    Options.withDescription("$FPRINTPROMPT, current fingerprint auth prompt."),
    Options.withDefault("Please auth:")
)

const cmd_op_auth_fprint_fail_msg = Options.text("auth-fprint-fail-msg").pipe(
    Options.withDescription("$FPRINTFAIL, last fingerprint auth fail reason."),
    Options.withDefault("Unknown error!")
)

const cmd_ops = {
    user: cmd_op_user,
    user_desc: cmd_op_user_desc,
    time: cmd_op_time,
    time_12: cmd_op_time_12,
    kb_layout: cmd_op_kb_layout,
    auth_fail_num: cmd_op_auth_fail_num,
    auth_fail_msg: cmd_op_auth_fail_msg,
    auth_pam_prompt_msg: cmd_op_auth_pam_prompt_msg,
    auth_pam_fail_msg: cmd_op_auth_pam_fail_msg,
    auth_fprint_prompt_msg: cmd_op_auth_fprint_prompt_msg,
    auth_fprint_fail_msg: cmd_op_auth_fprint_fail_msg,
}

type t_parsed_cmd_ops = Command.Command.ParseConfig<typeof cmd_ops>

const cmd_handler = (ops: t_parsed_cmd_ops) => Effect.gen(function* () {
    const trimmed_auth_fprint_fail_msg = ops.auth_fprint_fail_msg.trim()
    const trimmed_auth_fprint_prompt_msg = ops.auth_fprint_prompt_msg.trim()
    const txt = trimmed_auth_fprint_fail_msg === "" ? trimmed_auth_fprint_prompt_msg : trimmed_auth_fprint_fail_msg
    yield* Console.log(txt)
})

const cmd = Command.make("hyprlock-hint", cmd_ops).pipe(
    Command.withHandler(cmd_handler)
)

const cli = pipe(
    cmd,
    Command.run({
        name: "hyprlock-hint",
        version: "v1.0.0"
    })
)

cli(Bun.argv).pipe(
    Effect.provide(BunContext.layer),
    BunRuntime.runMain
)