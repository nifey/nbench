/***************************************************************************
 *cr
 *cr            (C) Copyright 2010 The Board of Trustees of the
 *cr                        University of Illinois
 *cr                         All Rights Reserved
 *cr
 ***************************************************************************/

/*############################################################################*/

#include "main.h"
#include "lbm.h"
#include <stdio.h>
#include <stdlib.h>

#include <sys/stat.h>

/*############################################################################*/
static LBM_Grid CUDA_srcGrid, CUDA_dstGrid;


/*############################################################################*/

struct pb_TimerSet timers;
int main( int nArgs, char* arg[] ) {
	MAIN_Param param;
	int t;

	pb_InitializeTimerSet(&timers);
        struct pb_Parameters* params;
        params = pb_ReadParameters(&nArgs, arg);
        

	static LBM_GridPtr TEMP_srcGrid;
	//Setup TEMP datastructures
	MAIN_parseCommandLine( nArgs, arg, &param, params );
	MAIN_printInfo( &param );

	MAIN_initialize( &param );

	for( t = 1; t <= param.nTimeSteps; t++ ) {
                pb_SwitchToTimer(&timers, pb_TimerID_KERNEL);
		CUDA_LBM_performStreamCollide( CUDA_srcGrid, CUDA_dstGrid );
                pb_SwitchToTimer(&timers, pb_TimerID_COMPUTE);
		LBM_swapGrids( &CUDA_srcGrid, &CUDA_dstGrid );

		if( (t & 63) == 0 ) {
			printf( "timestep: %i\n", t );
#if 0
			LBM_showGridStatistics( *CUDA_srcGrid );
#endif
		}
	}

	MAIN_finalize( &param );

        pb_SwitchToTimer(&timers, pb_TimerID_NONE);
        pb_PrintTimerSet(&timers);
        pb_FreeParameters(params);
	return 0;
}

/*############################################################################*/

void MAIN_parseCommandLine( int nArgs, char* arg[], MAIN_Param* param, struct pb_Parameters * params ) {
	struct stat fileStat;

	if( nArgs < 2 ) {
		printf( "syntax: lbm <time steps>\n" );
		exit( 1 );
	}

	param->nTimeSteps     = atoi( arg[1] );

	if( params->inpFiles[0] != NULL ) {
		param->obstacleFilename = params->inpFiles[0];

		if( stat( param->obstacleFilename, &fileStat ) != 0 ) {
			printf( "MAIN_parseCommandLine: cannot stat obstacle file '%s'\n",
					param->obstacleFilename );
			exit( 1 );
		}
		if( fileStat.st_size != SIZE_X*SIZE_Y*SIZE_Z+(SIZE_Y+1)*SIZE_Z ) {
			printf( "MAIN_parseCommandLine:\n"
					"\tsize of file '%s' is %i bytes\n"
					"\texpected size is %i bytes\n",
					param->obstacleFilename, (int) fileStat.st_size,
					SIZE_X*SIZE_Y*SIZE_Z+(SIZE_Y+1)*SIZE_Z );
			exit( 1 );
		}
	}
	else param->obstacleFilename = NULL;

        param->resultFilename = params->outFile;
}

/*############################################################################*/

void MAIN_printInfo( const MAIN_Param* param ) {
	printf( "MAIN_printInfo:\n"
			"\tgrid size      : %i x %i x %i = %.2f * 10^6 Cells\n"
			"\tnTimeSteps     : %i\n"
			"\tresult file    : %s\n"
			"\taction         : %s\n"
			"\tsimulation type: %s\n"
			"\tobstacle file  : %s\n\n",
			SIZE_X, SIZE_Y, SIZE_Z, 1e-6*SIZE_X*SIZE_Y*SIZE_Z,
			param->nTimeSteps, param->resultFilename, 
			"store", "lid-driven cavity",
			(param->obstacleFilename == NULL) ? "<none>" :
			param->obstacleFilename );
}

/*############################################################################*/

void MAIN_initialize( const MAIN_Param* param ) {
        pb_SwitchToTimer(&timers, pb_TimerID_COMPUTE);
	//Setup TEMP datastructures
	LBM_allocateGrid( (float**) &CUDA_srcGrid );
	LBM_allocateGrid( (float**) &CUDA_dstGrid );
	LBM_initializeGrid( CUDA_srcGrid );
	LBM_initializeGrid( CUDA_dstGrid );

        pb_SwitchToTimer(&timers, pb_TimerID_IO);
	if( param->obstacleFilename != NULL ) {
		LBM_loadObstacleFile( CUDA_srcGrid, param->obstacleFilename );
		LBM_loadObstacleFile( CUDA_dstGrid, param->obstacleFilename );
	}

        pb_SwitchToTimer(&timers, pb_TimerID_COMPUTE);
	LBM_initializeSpecialCellsForLDC( CUDA_srcGrid );
	LBM_initializeSpecialCellsForLDC( CUDA_dstGrid );
	LBM_showGridStatistics( CUDA_srcGrid );
}

/*############################################################################*/

void MAIN_finalize( const MAIN_Param* param ) {
        pb_SwitchToTimer(&timers, pb_TimerID_COMPUTE);
	CUDA_LBM_syncrhonize();
	LBM_showGridStatistics( CUDA_srcGrid );

	LBM_storeVelocityField( CUDA_srcGrid, param->resultFilename, TRUE );

	LBM_freeGrid( (float**) &CUDA_srcGrid );
	LBM_freeGrid( (float**) &CUDA_dstGrid );
}

