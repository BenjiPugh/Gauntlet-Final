function lidar_cap()
    phi = deg2rad(30);
    a = 0.5;
    b = -2;
    psi = deg2rad(25);
    c = 1.5;
    d = 0;
    sub = rossubscriber('/scan');
    % place Neato at the origin pointing in the ihat_G direction
    placeNeato(0,-2,1,0)
    % wait a while for the Neato to fall into place
    pause(2);
    % Collect data at the room origin
    scan_message = receive(sub);
    r_1 = scan_message.Ranges(1:end-1);
    theta_1 = deg2rad([0:359]');
    % place Neato at the origin pointing in a different direction
    placeNeato(0,0,cos(phi),sin(phi))
    % wait a while for the Neato to fall into place
    pause(2);
    % Then collect data for the second location
    scan_message = receive(sub);
    r_2 = scan_message.Ranges(1:end-1);
    theta_2 = deg2rad([0:359]');
    % place Neato at a new position (a,b)_G with ihat_N oriented parallel to ihat_G
    placeNeato(a,b,1,0)
    % wait a while for the Neato to fall into place
    pause(2);
    scan_message = receive(sub);
    r_3 = scan_message.Ranges(1:end-1);
    theta_3 = deg2rad([0:359]');
    % place Neato at an arbitrary position and orientation
    placeNeato(c,d,cos(psi),sin(psi))
    % wait a while for the Neato to fall into place
    pause(2);
    scan_message = receive(sub);
    r_4 = scan_message.Ranges(1:end-1);
    theta_4 = deg2rad([0:359]');
    % Shove everything into a matrix (you can use the matrix or the
    % individual r_x and theta_x variables
    r_all = [r_1 r_2 r_3 r_4];
    theta_all = [theta_1 theta_2 theta_3 theta_4];
    P_1_GN = make_pose(0, -2, 0);
    P_2_GN = make_pose(0, 0, phi);
    P_3_GN = make_pose(a, b, 0);
    P_4_GN = make_pose(c, d, psi);
    lidar_offset = -0.084;
    P_NL = [1 0 lidar_offset; 0 1 0; 0 0 1];
    % could do more conciesly with a 3D array
    points_1 = [r_1.*cos(theta_1) r_1.*sin(theta_2) ones(length(theta_1), 1)]';
    points_2 = [r_2.*cos(theta_2) r_2.*sin(theta_2) ones(length(theta_2), 1)]';
    points_3 = [r_3.*cos(theta_3) r_3.*sin(theta_3) ones(length(theta_3), 1)]';
    points_4 = [r_4.*cos(theta_4) r_4.*sin(theta_4) ones(length(theta_4), 1)]';
    points_1 = P_1_GN*P_NL*points_1;
    points_2 = P_2_GN*P_NL*points_2;
    points_3 = P_3_GN*P_NL*points_3;
    points_4 = P_4_GN*P_NL*points_4;
    plot(points_1(1, :), points_1(2, :), ".", points_2(1, :), points_2(2, :), ".", points_3(1, :), points_3(2, :), ".", points_4(1, :), points_4(2, :), ".");
    xlabel("X (meters)");
    ylabel("Y (meters)");
    legend(["Scan 1", "Scan 2", "Scan 3", "Scan 4"]);
    title("Neato LIDAR Scans in the Global Reference Frame");

    function pose = make_pose(x, y, theta)
     pose = [cos(theta), -sin(theta), x;
     sin(theta), cos(theta), y;
     0, 0, 1];
    end
end