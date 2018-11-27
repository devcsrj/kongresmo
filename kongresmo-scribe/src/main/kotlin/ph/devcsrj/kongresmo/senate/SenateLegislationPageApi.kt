package ph.devcsrj.kongresmo.senate

import retrofit2.Call
import retrofit2.http.*

/**
 * Interface for fetching Senate-related data
 */
internal interface SenateLegislationPageApi {

    @GET("/lis/leg_sys.aspx")
    fun fetch(
        @Query("congress") congress: Int,
        @Query("type") type: String,
        @Query("p") page: Int
    ): Call<LegislationsPage>

    @FormUrlEncoded
    @POST("/lis/bill_res.aspx")
    fun fetchOne(
        @Query("congress") congress: Int,
        @Query("q") number: String,
        @Field("__EVENTTARGET") facet: String): Call<LegislationPage>
}
