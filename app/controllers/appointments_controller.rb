class AppointmentsController < ApplicationController
    def new
    end

    def create
        # render plain: params[:appointment].inspect

        # day = (params[:appointment])["Date(3i)"]
        # month = (params[:appointment])["Date(2i)"]
        # year = (params[:appointment])["Date(1i)"]
        # hour = (params[:appointment])["Date(4i)"]
        # minute = (params[:appointment])["Date(5i)"]
        # @prev_appt = Appointment.find_by_Valid("Yes")
        # if ( (@prev_appt[Date]).month ==3)
        #     render 'new'
        # else
        #     render 'appterror'
        # end

        # render plain: ( (@prev_appt[Date]).min ).inspect

        if (is_appointment_available==1)
            @appointment = Appointment.new(appointment_params)
            if ( check_for_future_appt( (@appointment[Date]).day, (@appointment[Date]).month, (@appointment[Date]).year, (@appointment[Date]).hour, (@appointment[Date]).min )==1)
                if @appointment.save
                    redirect_to @appointment
                else
                    render 'new'
                end
            else
                render 'appointment_future_error'
            end
        else
            render 'appointment_unavailable_error'
        end
    end

    def index
        # @appointments = Appointment.all

        # @to_update=Appointment.find_by_Valid("Yes")
        # if (@to_update!=nil)
        #     if ( check( (@to_update[Date]).day, (@to_update[Date]).month, (@to_update[Date]).year, (@to_update[Date]).hour, (@to_update[Date]).min )==1)
        #         @to_update.update_attribute(:Valid, "No")
        #     end 
        # end  
        update_old_appt_if_any 
        @appointments = Appointment.all

    end

    def show
        @appointment = Appointment.find(params[:id])
    end

    def destroy
        @appointment = Appointment.find(params[:id])
        @appointment.destroy

        redirect_to appointments_path
    end


    private

    def update_old_appt_if_any
        @to_update=Appointment.find_by_Valid("Yes")
        if (@to_update!=nil)
            if ( check( (@to_update[Date]).day, (@to_update[Date]).month, (@to_update[Date]).year, (@to_update[Date]).hour, (@to_update[Date]).min )==1)
                @to_update.update_attribute(:Valid, "No")
            end 
        end
    end

    def check(day, month, year, hour, minute)
        ctime = Time.now
        if (year<=ctime.year && month<=ctime.month && day<=ctime.day && hour<=ctime.hour && minute<=ctime.min)
            1
        else
            0
        end
    end

    def check_for_future_appt(day, month, year, hour, minute)
        ctime = Time.now
        if (year>=ctime.year && month>=ctime.month && day>=ctime.day && hour>ctime.hour && minute>ctime.min)
            1
        else
            0
        end
    end

    def appointment_params
        temp_hash = params.require(:appointment).permit(:Date)
        hash = {"Valid" => "Yes"}
        hash.merge(temp_hash)
    end

    def is_appointment_available
        update_old_appt_if_any

        @appointments = Appointment.find_by_Valid("Yes")
        if (@appointments!=nil)
            0
        else
            1
        end
        # @appointments = Appointment.find_by(Valid: "No")
        # @appointments = Appointment.find(Valid: "No")
        # if @appointments==nil
        #     render 'appterror'
        # end
        # @appointments = Appointment.where(Valid: 'Yes')
    end
end
