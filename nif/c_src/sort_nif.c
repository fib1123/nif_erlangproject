#include "erl_nif.h"

extern int quicksorthybrid(int* array, int l, int r);

static ERL_NIF_TERM sort_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    int* input;
    int N;

    if (!enif_get_list_length(env, argv[0], &N)) {
	    return enif_make_badarg(env);
    }

    int i = 0;
    ERL_NIF_TERM head, tail;
    ERL_NIF_TERM currList = argv[0];
    while(enif_get_list_cell(env, currList, &head, &tail)) {
        if(!enif_get_int(env, head, input + i)) {
            return enif_make_badarg(env);
        }
        i++;
        currList = tail;
    }

    quicksorthybrid(input, 0, N-1);

    ERL_NIF_TERM res[N];
    i = 0;
    while (i < N) {
        res[i] = enif_make_int(env, input[i]);
        i++;
    }

    return enif_make_list_from_array(env, res, N);
}


static ErlNifFunc nif_funcs[] = {
    {"sort", 1, sort_nif}
};

ERL_NIF_INIT(sort_nif, nif_funcs, NULL, NULL, NULL, NULL)