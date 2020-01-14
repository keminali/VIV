/* solver the equation of motion using 4th order runge kutta*/
/* authors: guo fei, ai kaiming, HIT */
#include "udf.h" 
#include "sg_mem.h" 
#include "dynamesh_tools.h" /* Header files  which enables both the definition of DEFINE macros and other ANSYS Fluent-provided macros and functions, and their inclusion in the compilation process*/

#define mass   0.0138 /* global variable, mass is derived by a given mass ratio, m*/
#define dtm    0.005/* time step size */
#define freq   84.2369 /*omega^2 */
#define ksi    0.0994 /* omega*\xi */

/* initial values, for dis-continuous calculation, you need to reset these values to the values of last time step */
real b_vel[ND_ND]={0,-0.092983,0}; /* initial velocity variables, [0] mean x coordinates, r[1] means y coordinates */
real b_cen[ND_ND]={0,0.057577,0}; /* initial displacenment variables */
real t; /* time variable*/
FILE *fp; /* file pointer */
/***********************************************************************/
DEFINE_EXECUTE_AT_END(exe_end)  /* Fluent calls the function at the end of an iteration */
{
 int i;
/* x_cg   ==>> displacement vector, x_cg[0] is x component */
/* f_glob | force vector, f_glob[1] is y coordinate force*/
 real x_cg[ND_ND],f_glob[ND_ND],m_glob[ND_ND]; 
 real vn,yn,Vn,Yn; 
 real K1,K2,K3,K4;  /* coefficients in runge-kuttee methods*/

 Domain *domain=Get_Domain(1); /* */
 Thread *tf=Lookup_Thread(domain,14);  /* thread point*/


 for(i=0; i<ND_ND; i++) /* for loop */
 {
  x_cg[i]=0;
  f_glob[i]=0;
  m_glob[i]=0; /* set variables to 0 */
 }

 for(i=0; i<ND_ND; i++) /* for loop */
 x_cg[i]=b_cen[i]; /* assign the displacement of last time step to variable 'x_cg' */

 Compute_Force_And_Moment(domain,tf,x_cg,f_glob,m_glob,TRUE); /* Compute_Force_And_Moment (domain, tf, CG, force, moment, FALSE);*/
  
 vn=b_vel[1]; /* initial velocity*/
 yn=b_cen[1]; /* */

  K1=f_glob[1]/mass-ksi*vn-freq*yn; 
  K2=f_glob[1]/mass-ksi*(vn+K1*dtm/2)-freq*(yn+vn*dtm/2); 
  K3=f_glob[1]/mass-ksi*(vn+K2*dtm/2)-freq*(yn+vn*dtm/2+dtm*dtm*K1/4); 
  K4=f_glob[1]/mass-ksi*(vn+K3*dtm)-freq*(yn+vn*dtm+dtm*dtm*K2/2);  /* coefficients in runge-kutte, here, damping is 0, freq= omega^2 */
  
  Vn=vn+dtm*(K1+2*K2+2*K3+K4)/6; /* velocity at current time step */
  Yn=yn+dtm*vn+dtm*dtm*(K1+K2+K3)/6;   /*displacement at current time step */
  b_vel[1]=Vn; 
  b_cen[1]=Yn; 


  t=t+dtm; /* time increment */

    fp=fopen("output.txt","a"); /* append data to 'output.txt' */
  fprintf(fp,"%5f,%5f,%8f,%8f,%8f\n",CURRENT_TIME,t,x_cg[1],f_glob[1],b_vel[1]);  /* write: current time, time, displacement, force, velocity */
   fclose(fp);/* close file*/
}
/***********************************************************************/

/* specify the motion of cylinder BL, assign velocity calculated in the above to the cylinder */
DEFINE_CG_MOTION(cylinder,dt,vel,omega,time,dtime) /* */
{ 
   NV_S(vel,=,0.0);  /* initialization, velocity is 0*/
   NV_S(omega,=,0.0); /* initialization, displacement is 0 */
   vel[1]=b_vel[1];   
} 
