class AppointmentsController < ApplicationController
    before_action :authenticate_user!, except: [:index]

    def new
        # @appointment = Appointment.new
        @appointment = current_user.appointments.build
    end

    def search_get
    end

    def search_show
        update_old_appt_if_any
        @query = Appointment.new(appointment_params)
        # render plain: @query[Date].inspect
        # @query =  params[:appointment]
        # @query =  params.require(:appointment).permit(:Date)
        # render plain: @query.inspect.to_s
        # (@appointment[Date]).year

        @all = Appointment.all
        @all_answers = []

        for i in 0..(@all.length - 1)
            if ( ((@all[i][Date]).year==@query[Date].year) && ((@all[i][Date]).month==@query[Date].month) && ((@all[i][Date]).day==@query[Date].day))
                @all_answers = @all_answers + [@all[i]]
            end
        end       
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

        # @app = Appointment.where(:Valid => "Yes")
        # @dummy = Appointment.new(appointment_params)
        # @dummy[Date] = @dummy[Date].change(min: 0)
        # render text: ( @app[0].Date==@dummy[Date] ).inspect
        # # render text: ( @app[0].Date ).inspect
        # # render text: ( @dummy[Date] ).inspect

        # @dummy = Appointment.new(appointment_params)
        # @dummy[Date] = @dummy[Date].change(min: 0)
        # @app = Appointment.where(:Valid => "Yes")
        # for j in 0..((@app.length)-1)
        #     if (@app[j].Date == @dummy[Date])
        #         # return 0
        #         render text: ( "Exact Date Match Found" ).inspect
        #     end
        # end
        

        @dummy = Appointment.new(appointment_params)
        @dummy[Date] = @dummy[Date].change(min: 0)
        is_safe = can_take_valid_appt(@dummy[Date])
        if (is_safe==1)
            # @appointment = Appointment.new(appointment_params)
            @appointment = current_user.appointments.build(appointment_params)
            @appointment[Date] = @appointment[Date].change(min: 0)
            if ( check_for_future_appt( (@appointment[Date]).day, (@appointment[Date]).month, (@appointment[Date]).year, (@appointment[Date]).hour, (@appointment[Date]).min )==1)
                if @appointment.save
                    redirect_to @appointment
                else
                    render 'new'
                end
            else
                render 'appointment_future_error'
            end
        elsif (is_safe==0)
            render 'appointment_unavailable_error'
        else
            render 'appt_clash_error'
        end

        # # just save and ignore every check
        # @appointment = current_user.appointments.build(appointment_params)
        # @appointment[Date] = @appointment[Date].change(min: 0)
        # @appointment.save
        # redirect_to @appointment
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
        @appointments = @appointments.sort_by(&:Date)

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
        if (year>ctime.year)
            1
        elsif (year>=ctime.year && month>ctime.month)
            1
        elsif (year>=ctime.year && month>=ctime.month && day>ctime.day)
            1
        elsif (year>=ctime.year && month>=ctime.month && day>=ctime.day && hour>ctime.hour)
            1
        elsif (year>=ctime.year && month>=ctime.month && day>=ctime.day && hour>=ctime.hour && minute>ctime.min)
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

    def can_take_valid_appt(date_entered)
        update_old_appt_if_any

        @app = Appointment.where(:Valid => "Yes")
        num_records = @app.length
        if (num_records!=0) # there are some valid records
            # search through all the appointments looking for an appointment already registered by the same user
            for i in 0..(num_records-1)
                if (@app[i].user_id == current_user.id)
                    return 0
                end
            end

            # search through all the appointments looking for a time that is equal to the time user register
            for j in 0..(num_records-1)
                if (@app[j].Date == date_entered)
                    return 2
                end
            end
            return 1
        else
            return 1
        end



        # update_old_appt_if_any

        # @appointments = Appointment.find_by_Valid("Yes")
        # if (@appointments!=nil)
        #     0
        # else
        #     1
        # end

        # @appointments = Appointment.find_by(Valid: "No")
        # @appointments = Appointment.find(Valid: "No")
        # if @appointments==nil
        #     render 'appterror'
        # end
        # @appointments = Appointment.where(Valid: 'Yes')
    end
end
