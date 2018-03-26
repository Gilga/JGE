#include <julia.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#if defined(_WIN32) || defined(_WIN64)
#include <malloc.h>
#endif

void failed_warning(void) {
    if (jl_base_module == NULL) { // image not loaded!
        char *julia_home = getenv("JULIA_HOME");
        if (julia_home) {
            fprintf(stderr,
                    "\nJulia init failed, "
                    "a possible reason is you set an envrionment variable named 'JULIA_HOME', "
                    "please unset it and retry.\n");
        }
    }
}

int main(int argc, char *argv[])
{
    char sysji[] = "libapp.dll";
    char *sysji_env = getenv("JULIA_SYSIMAGE");
    char mainfunc[] = "main()";

    assert(atexit(&failed_warning) == 0);

    jl_init_with_image(NULL, sysji_env == NULL ? sysji : sysji_env);

    // set Base.ARGS, not Core.ARGS
    if (jl_base_module != NULL) {
        jl_array_t *args = (jl_array_t*)jl_get_global(jl_base_module, jl_symbol("ARGS"));
        if (args == NULL) {
            args = jl_alloc_vec_any(0);
            jl_set_const(jl_base_module, jl_symbol("ARGS"), (jl_value_t*)args);
        }
        assert(jl_array_len(args) == 0);
        jl_array_grow_end(args, argc - 1);
        int i;
        for (i=1; i < argc; i++) {
            jl_value_t *s = (jl_value_t*)jl_cstr_to_string(argv[i]);
            jl_set_typeof(s,jl_string_type);
            jl_arrayset(args, s, i - 1);
        }
    }

    // call main
    jl_eval_string(mainfunc);

    int ret = 0;
    if (jl_exception_occurred())
    {
        jl_show(jl_stderr_obj(), jl_exception_occurred());
        jl_printf(jl_stderr_stream(), "\n");
        ret = 1;
    }

    jl_atexit_hook(ret);
    return ret;
}
